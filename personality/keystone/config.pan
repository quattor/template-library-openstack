unique template personality/keystone/config;

# User running Keystone daemons (normally created by RPMs)
variable KEYSTONE_USER ?= 'keystone';
variable KEYSTONE_GROUP ?= 'keystone';

# Generate the admin token with `openssl rand -hex 10`
variable ADMIN_TOKEN ?= error('ADMIN_TOKEN required but not specified');

# Base endpoints URLs for Keystone
variable PUBLIC_ENDPOINT ?= 'http://' + FULL_HOSTNAME + ':%(public_port)s/';
variable ADMIN_ENDPOINT ?= 'http://' + FULL_HOSTNAME + ':%(admin_port)s/';


# Database related variables
variable KEYSTONE_MYSQL_ADMINUSER ?= 'root';
variable KEYSTONE_MYSQL_ADMINPWD ?= error('CREAM_MYSQL_ADMINPWD required but not specified');
variable KEYSTONE_DB_NAME ?= 'keystone';
variable KEYSTONE_DB_USER ?= 'keystone';
variable KEYSTONE_DB_PASSWORD ?= error('KEYSTONE_DB_PASSWORD required but not specified');

variable SQL_CONNECTION ?= 'mysql://'+KEYSTONE_DB_USER+':'+KEYSTONE_DB_PASSWORD+'@'+KEYSTONE_MYSQL_SERVER+'/'+KEYSTONE_DB_NAME;


#------------------------------------------------------------------------------
# Keystone configuration
#------------------------------------------------------------------------------

variable KEYSTONE_CONFIG ?= '/etc/keystone/keystone.conf';

variable KEYSTONE_CONFIG_CONTENTS ?= file_contents('personality/keystone/templates/keystone.templ');

variable KEYSTONE_CONFIG_CONTENTS=replace('ADMIN_TOKEN',ADMIN_TOKEN,KEYSTONE_CONFIG_CONTENTS);
variable KEYSTONE_CONFIG_CONTENTS=replace('PUBLIC_ENDPOINT',PUBLIC_ENDPOINT,KEYSTONE_CONFIG_CONTENTS);
variable KEYSTONE_CONFIG_CONTENTS=replace('ADMIN_ENDPOINT',ADMIN_ENDPOINT,KEYSTONE_CONFIG_CONTENTS);
variable KEYSTONE_CONFIG_CONTENTS=replace('SQL_CONNECTION',SQL_CONNECTION,KEYSTONE_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(KEYSTONE_CONFIG), nlist(
        "config",KEYSTONE_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-keystone restart",
    ),
);


#------------------------------------------------------------------------------
# MySQL configuration
#------------------------------------------------------------------------------

include { 'components/mysql/config' };

'/software/components/mysql/servers/' = {
    SELF[KEYSTONE_MYSQL_SERVER]['adminuser'] = KEYSTONE_MYSQL_ADMINUSER;
    SELF[KEYSTONE_MYSQL_SERVER]['adminpwd'] = KEYSTONE_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases/' = {
    SELF[KEYSTONE_DB_NAME]['server'] = KEYSTONE_MYSQL_SERVER;
    SELF[KEYSTONE_DB_NAME]['users'][KEYSTONE_DB_USER] = nlist(
        'password', KEYSTONE_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};


# ---------------------------------------------------------------------------- 
# Enable and start Keystone service
# ---------------------------------------------------------------------------- 

include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/openstack-keystone/on" = ""; 
"/software/components/chkconfig/service/openstack-keystone/startstop" = true; 
