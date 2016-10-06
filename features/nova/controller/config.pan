unique template features/nova/controller/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Include utils
include 'defaults/openstack/utils';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/nova/controller/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-nova-api/on' = '';
'openstack-nova-api/startstop' = true;
'openstack-nova-cert/on' = '';
'openstack-nova-cert/startstop' = true;
'openstack-nova-consoleauth/on' = '';
'openstack-nova-consoleauth/startstop' = true;
'openstack-nova-scheduler/on' = '';
'openstack-nova-scheduler/startstop' = true;
'openstack-nova-conductor/on' = '';
'openstack-nova-conductor/startstop' = true;
'openstack-nova-novncproxy/on' = '';
'openstack-nova-novncproxy/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_config;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'daemons/openstack-nova-api'='restart';
'daemons/openstack-nova-cert'='restart';
'daemons/openstack-nova-consoleauth'='restart';
'daemons/openstack-nova-scheduler'='restart';
'daemons/openstack-nova-conductor'='restart';
'daemons/openstack-nova-novncproxy'='restart';
# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/network_api_class' = 'nova.network.neutronv2.api.API';
'contents/DEFAULT/security_group_api' = 'neutron';
'contents/DEFAULT/linuxnet_interface_driver' = 'nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver';
'contents/DEFAULT/firewall_driver' = 'nova.virt.firewall.NoopFirewallDriver';
'contents/DEFAULT/enabled_apis' = 'osapi_compute,metadata';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT/ssl_cert_file' = if ( OPENSTACK_SSL ) {
  OPENSTACK_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/ssl_key_file' = if ( OPENSTACK_SSL ) {
  OPENSTACK_SSL_KEY;
} else {
  null;
};
'contents/DEFAULT/enabled_ssl_apis' = if ( OPENSTACK_SSL ) {
  'osapi_compute';
} else {
  null;
};
# Enable SSL for novnc
'contents/DEFAULT/cert' = if ( OPENSTACK_SSL ) {
  OPENSTACK_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/key' = if ( OPENSTACK_SSL ) {
  OPENSTACK_SSL_KEY;
} else {
  null;
};
'contents/DEFAULT/ssl_only' = if ( OPENSTACK_SSL ) {
  'True';
} else {
  null;
};
'contents/DEFAULT/cpu_allocation_ratio' = OPENSTACK_NOVA_CPU_RATIO;
'contents/DEFAULT/ram_allocation_ratio' = OPENSTACK_NOVA_RAM_RATIO;

# [database] section
'contents/database/connection' = openstack_dict_to_connection_string(OPENSTACK_NOVA_DB);
# [api_database] section
'contents/api_database/connection' = openstack_dict_to_connection_string(OPENSTACK_NOVA_API_DB);

# [glance] section
#'contents/glance/host' = OPENSTACK_GLANCE_CONTROLLER_HOST;
#'contents/glance/protocol' = OPENSTACK_GLANCE_CONTROLLER_PROTOCOL;
'contents/glance/api_servers' = OPENSTACK_GLANCE_CONTROLLER_PROTOCOL+'://'+OPENSTACK_GLANCE_CONTROLLER_HOST+':9292';

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_NOVA_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_NOVA_PASSWORD;

# [neutron] section
'contents/neutron/url' = OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL + '://' + OPENSTACK_NEUTRON_CONTROLLER_HOST + ':9696';
'contents/neutron/auth_url' = OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OPENSTACK_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/neutron/auth_plugin' = 'password';
'contents/neutron/auth_type' = 'password';
'contents/neutron/project_domain_name' = 'default';
'contents/neutron/user_domain_name' = 'default';
'contents/neutron/region_name' = OPENSTACK_REGION_NAME;
'contents/neutron/project_name' = 'service';
'contents/neutron/username' = OPENSTACK_NEUTRON_USERNAME;
'contents/neutron/password' = OPENSTACK_NEUTRON_PASSWORD;
'contents/neutron/service_metadata_proxy' = 'True';
'contents/neutron/metadata_proxy_shared_secret' = OPENSTACK_METADATA_SECRET;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [vnc] section
'contents/vnc/vncserver_listen' = '$my_ip';
'contents/vnc/vncserver_proxyclient_address' = '$my_ip';

include if (OPENSTACK_HA) {
    'features/nova/controller/ha';
} else {
    null;
};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-nova.sh}' = dict(
  'perms' ,'755',
  'config', format(
    file_contents('features/nova/controller/init-nova.sh'),
    OPENSTACK_INIT_SCRIPT_GENERAL,
    OPENSTACK_NOVA_CONTROLLER_HOST,
    OPENSTACK_NOVA_USERNAME,
    OPENSTACK_NOVA_PASSWORD,
  ),
  'restart' , '/root/init-nova.sh',
);
