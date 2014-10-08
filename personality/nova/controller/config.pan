template personality/nova/controller/config; 

variable NOVA_SERVICES ?= list('openstack-nova-api','openstack-nova-cert','openstack-consoleauth','openstack-nova-scheduler','openstack-nova-conductor','openstack-nova-novncproxy');
variable VNCSERVER_LISTEN ?= DB_IP[escape(FULL_HOSTNAME)];

# include configuration common to client and server
include { 'personality/nova/config' };

# Database related variables
variable NOVA_MYSQL_ADMINUSER ?= 'root';
variable NOVA_MYSQL_ADMINPWD ?= error('NOVA_MYSQL_ADMINPWD required but not specified');

#------------------------------------------------------------------------------
# MySQL configuration
#------------------------------------------------------------------------------

include { 'components/mysql/config' };

'/software/components/mysql/servers/' = {
    SELF[NOVA_MYSQL_SERVER]['adminuser'] = NOVA_MYSQL_ADMINUSER;
    SELF[NOVA_MYSQL_SERVER]['adminpwd'] = NOVA_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases/' = {
    SELF[NOVA_DB_NAME]['server'] = NOVA_MYSQL_SERVER;
    SELF[NOVA_DB_NAME]['users'][NOVA_DB_USER] = nlist(
        'password', NOVA_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};

#------------------------------------------------------------------------------
# Endpoint configuration script
#------------------------------------------------------------------------------

variable NOVA_ENDPOINTS ?= '/root/sbin/create-nova-endpoints.sh';
variable NOVA_ENDPOINTS_CONTENTS ?= file_contents('personality/nova/server/templates/create-nova-endpoints.templ');

variable NOVA_ENDPOINTS_CONTENTS = replace('NOVA_KEYSTONE_PASSWORD',NOVA_KEYSTONE_PASSWORD,NOVA_ENDPOINTS_CONTENTS);
variable NOVA_ENDPOINTS_CONTENTS = replace('NOVA_EMAIL',NOVA_EMAIL,NOVA_ENDPOINTS_CONTENTS);
variable NOVA_ENDPOINTS_CONTENTS = replace('NOVA_PUBLIC_HOST',NOVA_PUBLIC_HOST,NOVA_ENDPOINTS_CONTENTS);
variable NOVA_ENDPOINTS_CONTENTS = replace('NOVA_INTERNAL_HOST',NOVA_INTERNAL_HOST,NOVA_ENDPOINTS_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NOVA_ENDPOINTS), nlist(
        "config",NOVA_ENDPOINTS_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);
