unique template personality/cinder/server/config;

variable CINDER_SERVICES ?= list('openstack-cinder-api','openstack-cinder-scheduler');
variable CINDER_EMAIL ?= SITE_EMAIL;

# include configuration common to all Cinder components
include { 'personality/cinder/config' };

# Database related variables
variable CINDER_MYSQL_ADMINUSER ?= 'root';
variable CINDER_MYSQL_ADMINPWD ?= error('CREAM_MYSQL_ADMINPWD required but not specified');


#------------------------------------------------------------------------------
# MySQL configuration
#------------------------------------------------------------------------------

include { 'components/mysql/config' };

'/software/components/mysql/servers/' = {
    SELF[CINDER_MYSQL_SERVER]['adminuser'] = CINDER_MYSQL_ADMINUSER;
    SELF[CINDER_MYSQL_SERVER]['adminpwd'] = CINDER_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases/' = {
    SELF[CINDER_DB_NAME]['server'] = CINDER_MYSQL_SERVER;
    SELF[CINDER_DB_NAME]['users'][CINDER_DB_USER] = nlist(
        'password', CINDER_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};


#------------------------------------------------------------------------------
# Endpoint configuration script
#------------------------------------------------------------------------------

variable CINDER_ENDPOINTS ?= '/root/sbin/create-cinder-endpoints.sh';
variable CINDER_ENDPOINTS_CONTENTS ?= file_contents('personality/cinder/server/templates/create-cinder-endpoints.templ');

variable CINDER_ENDPOINTS_CONTENTS = replace('CINDER_KEYSTONE_PASSWORD',CINDER_KEYSTONE_PASSWORD,CINDER_ENDPOINTS_CONTENTS);
variable CINDER_ENDPOINTS_CONTENTS = replace('CINDER_EMAIL',CINDER_EMAIL,CINDER_ENDPOINTS_CONTENTS);
variable CINDER_ENDPOINTS_CONTENTS = replace('CINDER_HOSTNAME',FULL_HOSTNAME,CINDER_ENDPOINTS_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(CINDER_ENDPOINTS), nlist(
        "config",CINDER_ENDPOINTS_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);
