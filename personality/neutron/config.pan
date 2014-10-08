template personality/neutron/config;

variable NEUTRON_KEYSTONE_TENANT ?= 'service';
variable NEUTRON_KEYSTONE_USER ?= 'neutron';
variable NEUTRON_KEYSTONE_PASSWORD ?= error('NEUTRON_KEYSTONE_PASSWORD required but not specified');

# Database related variables
variable NEUTRON_MYSQL_SERVER ?= MYSQL_HOST;
variable NEUTRON_DB_NAME ?= 'nova';
variable NEUTRON_DB_USER ?= 'nova';
variable NEUTRON_DB_PASSWORD ?= error('NEUTRON_DB_PASSWORD required but not specified');

variable NEUTRON_SQL_CONNECTION ?= 'mysql://'+NEUTRON_DB_USER+':'+NEUTRON_DB_PASSWORD+'@'+NEUTRON_MYSQL_SERVER+'/'+NEUTRON_DB_NAME;

variable NEUTRON_NETWORK_PLUGIN ?= 'openvswitch';

#----------------------------------------------------------------------------
# Neutron configuration
#----------------------------------------------------------------------------

variable NEUTRON_CONFIG ?= '/etc/neutron/neutron.conf';

variable NEUTRON_CONFIG_CONTENTS ?= file_contents('personality/neutron/templates/neutron.templ');

variable NEUTRON_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('SQL_CONNECTION',NEUTRON_SQL_CONNECTION,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('KEYSTONE_PROTOCOL',KEYSTONE_PROTOCOL,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NEUTRON_KEYSTONE_TENANT',NEUTRON_KEYSTONE_TENANT,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NEUTRON_KEYSTONE_USER',NEUTRON_KEYSTONE_USER,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NEUTRON_KEYSTONE_PASSWORD',NEUTRON_KEYSTONE_PASSWORD,NEUTRON_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NEUTRON_CONFIG), nlist(
        "config",NEUTRON_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-neutron restart",
    ),
);

#----------------------------------------------------------------------------
# Network plugin
#----------------------------------------------------------------------------

include { 'personality/neutron/plugins/' + NEUTRON_NETWORK_PLUGIN + '/' + NEUTRON_NODE_TYPE };


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;NEUTRON_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};
