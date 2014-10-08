unique template personality/cinder/config;

# User running Cinder daemons (normally created by RPMs)
variable CINDER_USER ?= 'cinder';
variable CINDER_GROUP ?= 'cinder';

variable CINDER_KEYSTONE_TENANT ?= 'service';
variable CINDER_KEYSTONE_USER ?= 'cinder';
variable CINDER_KEYSTONE_PASSWORD ?=  error('CINDER_KEYSTONE_PASSWORD required but not specified');

# MySQL-related variables
variable CINDER_DB_NAME ?= 'cinder';
variable CINDER_DB_USER ?= 'cinder';
variable CINDER_DB_PASSWORD ?= error('CINDER_DB_PASSWORD required but not specified');

variable CINDER_SQL_CONNECTION ?= 'mysql://'+CINDER_DB_USER+':'+CINDER_DB_PASSWORD+'@'+CINDER_MYSQL_SERVER+'/'+CINDER_DB_NAME;


#------------------------------------------------------------------------------
# Cinder configuration
#------------------------------------------------------------------------------

variable CINDER_CONFIG ?= '/etc/cinder/cinder.conf';

variable CINDER_CONFIG_CONTENTS ?= file_contents('personality/cinder/templates/cinder.templ');

variable CINDER_CONFIG_CONTENTS=replace('HOST_IP',DB_IP[escape(FULL_HOSTNAME)],CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('GLANCE_HOST',GLANCE_INTERNAL_HOST,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('RABBIT_USERID',RABBIT_USER,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('SQL_CONNECTION',CINDER_SQL_CONNECTION,CINDER_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(CINDER_CONFIG), nlist(
        "config",CINDER_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-cinder restart",
    ),
);


#------------------------------------------------------------------------------
# Cinder API configuration
#------------------------------------------------------------------------------

variable CINDER_API ?= '/etc/cinder/api-paste.ini';

variable CINDER_API_CONTENTS ?= file_contents('personality/cinder/templates/api-paste.templ');

variable CINDER_API_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('KEYSTONE_PROTOCOL',KEYSTONE_PROTOCOL,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_INTERNAL_ENDPOINT,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('CINDER_KEYSTONE_TENANT',CINDER_KEYSTONE_TENANT,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('CINDER_KEYSTONE_USER',CINDER_KEYSTONE_USER,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('CINDER_KEYSTONE_PASSWORD',CINDER_KEYSTONE_PASSWORD,CINDER_API_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(CINDER_API), nlist(
        "config",CINDER_API_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-cinder restart",
    ),
);


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;CINDER_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};
