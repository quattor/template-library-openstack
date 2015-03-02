template personality/neutron/config;

variable NEUTRON_KEYSTONE_TENANT ?= 'service';
variable NEUTRON_KEYSTONE_USER ?= 'neutron';
variable NEUTRON_KEYSTONE_PASSWORD ?= error('NEUTRON_KEYSTONE_PASSWORD required but not specified');

# Nova related variables
# Neutron related variables
variable NOVA_URL ?= 'http://' + NOVA_INTERNAL_HOST + ':8774';
variable NOVA_KEYSTONE_USER ?= 'nova';
variable NOVA_KEYSTONE_PASSWORD ?=error('NOVA_ADMIN_PASSWORD required but not specified');
variable NOVA_KEYSTONE_TENANT ?= 'service';
variable NOVA_KEYSTONE_AUTH_URL ?= KEYSTONE_INTERNAL_ENDPOINT;

# Database related variables
variable NEUTRON_MYSQL_SERVER ?= MYSQL_HOST;
variable NEUTRON_DB_NAME ?= 'nova';
variable NEUTRON_DB_USER ?= 'nova';
variable NEUTRON_DB_PASSWORD ?= error('NEUTRON_DB_PASSWORD required but not specified');

variable NEUTRON_SQL_CONNECTION ?= 'mysql://'+NEUTRON_DB_USER+':'+NEUTRON_DB_PASSWORD+'@'+NEUTRON_MYSQL_SERVER+'/'+NEUTRON_DB_NAME;

variable NEUTRON_NETWORK_PLUGIN ?= 'ml2';

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
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_URL',NOVA_URL,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_ADMIN_USERNAME',NOVA_KEYSTONE_USER,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_ADMIN_PASSWORD',NOVA_KEYSTONE_PASSWORD,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_ADMIN_TENANT',NOVA_KEYSTONE_TENANT,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_ADMIN_AUTH_URL',NOVA_KEYSTONE_AUTH_URL,NEUTRON_CONFIG_CONTENTS);

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

include { 'personality/neutron/plugins/' + NEUTRON_NETWORK_PLUGIN + '/config' };

# Link default plugin to plugin.ini file
include { 'components/symlink/config' };
variable NEUTRON_PLUGIN_TARGET ?= {
  if (NEUTRON_NETWORK_PLUGIN == 'ml2') {
    target = '/etc/neutron/plugins/ml2/ml2_conf.ini';
  } else if (NEUTRON_NETWORK_PLUGIN == 'openvswitch') {
    target = '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini';
  };

  target;
};
'/software/components/symlink/links'=push(
  nlist('name', '/etc/neutron/plugin.ini',
        'replace', nlist('all','yes','link','yes'),
        'target', NEUTRON_PLUGIN_TARGET,
  ),
);

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
