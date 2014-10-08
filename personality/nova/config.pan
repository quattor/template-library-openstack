template personality/nova/config; 

variable MY_IP ?= DB_IP[escape(FULL_HOSTNAME)];
variable VNCSERVER_LISTEN ?= "0.0.0.0";
variable VNCSERVER_PROXYCLIENT_ADDRESS ?= MY_IP;
variable NOVNCPROXY_BASE_URL ?= 'http://'+NOVA_PUBLIC_HOST+':6080/vnc_auto.html';
variable XVPVNCPROXY_BASE_URL ?= 'http://'+NOVA_PUBLIC_HOST+':6081/console';
variable NOVA_KEYSTONE_TENANT ?= 'service';
variable NOVA_KEYSTONE_USER ?= 'nova';
variable NOVA_KEYSTONE_PASSWORD ?= error('NOVA_KEYSTONE_PASSWORD required but not specified');

# Neutron related variables
variable NEUTRON_URL ?= 'http://' + NEUTRON_INTERNAL_HOST + ':9696';
variable NEUTRON_METADATA_PROXY_ENABLED ?= true;
variable METADATA_PROXY_SHARED_SECRET ?= '';
variable NEUTRON_ADMIN_NAME ?= 'neutron';
variable NEUTRON_ADMIN_PASSWORD ?=error('NEUTRON_ADMIN_PASSWORD required but not specified');
variable NEUTRON_ADMIN_TENANT ?= 'service';
variable NEUTRON_ADMIN_AUTH_URL ?= KEYSTONE_INTERNAL_ENDPOINT;
variable NEUTRON_REGION_NAME ?= 'regionOne';

# Database related variables
variable NOVA_MYSQL_SERVER ?= MYSQL_HOST;
variable NOVA_DB_NAME ?= 'nova';
variable NOVA_DB_USER ?= 'nova';
variable NOVA_DB_PASSWORD ?= error('NOVA_DB_PASSWORD required but not specified');

variable NOVA_SQL_CONNECTION ?= 'mysql://'+NOVA_DB_USER+':'+NOVA_DB_PASSWORD+'@'+NOVA_MYSQL_SERVER+'/'+NOVA_DB_NAME;


#------------------------------------------------------------------------------
# Nova Configuration
#------------------------------------------------------------------------------

variable NOVA_CONFIG ?= '/etc/nova/nova.conf';

variable NOVA_CONFIG_CONTENTS ?= file_contents('personality/nova/templates/nova.templ');

variable NOVA_CONFIG_CONTENTS=replace('MY_IP',MY_IP,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('VNCSERVER_LISTEN',VNCSERVER_LISTEN,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('VNCSERVER_PROXYCLIENT_ADDRESS',VNCSERVER_PROXYCLIENT_ADDRESS,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('XVPVNCPROXY_BASE_URL',XVPVNCPROXY_BASE_URL,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS={
  if (VNCSERVER_LISTEN == "0.0.0.0") {
    replace('#vnc_enabled=true','vnc_enabled=true',NOVA_CONFIG_CONTENTS);
  } else {
    NOVA_CONFIG_CONTENTS;
  };
};
variable NOVA_CONFIG_CONTENTS={
  if (VNCSERVER_LISTEN == "0.0.0.0") {
    replace('#novncproxy_base_url=http://127.0.0.1:6080/vnc_auto.html','novncproxy_base_url='+NOVNCPROXY_BASE_URL,NOVA_CONFIG_CONTENTS);
  } else {
    NOVA_CONFIG_CONTENTS;
  };
};
variable NOVA_CONFIG_CONTENTS=replace('GLANCE_HOST',GLANCE_INTERNAL_HOST,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('SQL_CONNECTION',NOVA_SQL_CONNECTION,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('KEYSTONE_PROTOCOL',KEYSTONE_PROTOCOL,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_KEYSTONE_TENANT',NOVA_KEYSTONE_TENANT,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_KEYSTONE_USER',NOVA_KEYSTONE_USER,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_KEYSTONE_PASSWORD',NOVA_KEYSTONE_PASSWORD,NOVA_CONFIG_CONTENTS);

# Neutron part
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_URL',NEUTRON_URL,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS={
  if (NEUTRON_METADATA_PROXY_ENABLED) {
    replace('NEUTRON_METADATA_PROXY_ENABLED','true',NOVA_CONFIG_CONTENTS);
  } else {
    replace('NEUTRON_METADATA_PROXY_ENABLED','false',NOVA_CONFIG_CONTENTS);
  };
};
variable NOVA_CONFIG_CONTENTS={
  if (NEUTRON_METADATA_PROXY_ENABLED) {
    replace('#neutron_metadata_proxy_shared_secret=METADATA_PROXY_SHARED_SECRET','neutron_metadata_proxy_shared_secret='+METADATA_PROXY_SHARED_SECRET,NOVA_CONFIG_CONTENTS);
  } else {
    NOVA_CONFIG_CONTENTS;
  };
};
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_URL',NEUTRON_URL,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_REGION_NAME',NEUTRON_REGION_NAME,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_ADMIN_NAME',NEUTRON_ADMIN_NAME,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_ADMIN_PASSWORD',NEUTRON_ADMIN_PASSWORD,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_ADMIN_TENANT',NEUTRON_ADMIN_TENANT,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_ADMIN_AUTH_URL',NEUTRON_ADMIN_AUTH_URL,NOVA_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NOVA_CONFIG), nlist(
        "config",NOVA_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-nova restart",
    ),
);


#------------------------------------------------------------------------------
# Nova API configuration
#------------------------------------------------------------------------------

variable NOVA_API ?= '/etc/nova/api-paste.ini';

variable NOVA_API_CONTENTS ?= file_contents('personality/nova/templates/api-paste.templ');

variable NOVA_API_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,NOVA_API_CONTENTS);
variable NOVA_API_CONTENTS=replace('KEYSTONE_PROTOCOL',KEYSTONE_PROTOCOL,NOVA_API_CONTENTS);
variable NOVA_API_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_INTERNAL_ENDPOINT,NOVA_API_CONTENTS);
variable NOVA_API_CONTENTS=replace('NOVA_KEYSTONE_TENANT',NOVA_KEYSTONE_TENANT,NOVA_API_CONTENTS);
variable NOVA_API_CONTENTS=replace('NOVA_KEYSTONE_USER',NOVA_KEYSTONE_USER,NOVA_API_CONTENTS);
variable NOVA_API_CONTENTS=replace('NOVA_KEYSTONE_PASSWORD',NOVA_KEYSTONE_PASSWORD,NOVA_API_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NOVA_API), nlist(
        "config",NOVA_API_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-nova restart",
    ),
);


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;NOVA_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};
