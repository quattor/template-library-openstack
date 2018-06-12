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
'openstack-nova-consoleauth/on' = '';
'openstack-nova-consoleauth/startstop' = true;
'openstack-nova-scheduler/on' = '';
'openstack-nova-scheduler/startstop' = true;
'openstack-nova-conductor/on' = '';
'openstack-nova-conductor/startstop' = true;
'openstack-nova-novncproxy/on' = '';
'openstack-nova-novncproxy/startstop' = true;
'httpd/on' = '';
'httpd/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_config;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'daemons/openstack-nova-api' = 'restart';
'daemons/openstack-nova-cert' = 'restart';
'daemons/openstack-nova-consoleauth' = 'restart';
'daemons/openstack-nova-scheduler' = 'restart';
'daemons/openstack-nova-conductor' = 'restart';
'daemons/openstack-nova-novncproxy' = 'restart';

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';
# [DEFAULT] section
'DEFAULT/rpc_backend' = 'rabbit';
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT/my_ip' = PRIMARY_IP;
'DEFAULT/use_neutron' = 'True';
'DEFAULT/linuxnet_interface_driver' = OPENSTACK_NOVA_LINUXNET_INTERFACE_DRIVER;
'DEFAULT/firewall_driver' = 'nova.virt.firewall.NoopFirewallDriver';
'DEFAULT/enabled_apis' = 'osapi_compute,metadata';
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/ssl_cert_file' = if ( OPENSTACK_SSL ) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'DEFAULT/ssl_key_file' = if ( OPENSTACK_SSL ) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};
'DEFAULT/enabled_ssl_apis' = if ( OPENSTACK_SSL ) {
    'osapi_compute';
} else {
    null;
};
# Enable SSL for novnc
'DEFAULT/cert' = if ( OPENSTACK_SSL ) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'DEFAULT/key' = if ( OPENSTACK_SSL ) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};
'DEFAULT/ssl_only' = if ( OPENSTACK_SSL ) {
    'True';
} else {
    null;
};
'DEFAULT/cpu_allocation_ratio' = OPENSTACK_NOVA_CPU_RATIO;
'DEFAULT/ram_allocation_ratio' = OPENSTACK_NOVA_RAM_RATIO;

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_NOVA_DB);
# [api_database] section
'api_database/connection' = openstack_dict_to_connection_string(OPENSTACK_NOVA_API_DB);

# [glance] section
#'glance/host' = openstack_get_controller_host(OPENSTACK_GLANCE_SERVERS);
#'glance/protocol' = OPENSTACK_GLANCE_CONTROLLER_PROTOCOL;
'glance/api_servers' = openstack_generate_uri(
    OPENSTACK_GLANCE_CONTROLLER_PROTOCOL,
    OPENSTACK_GLANCE_SERVERS,
    9292
);

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_NOVA_USERNAME;
'keystone_authtoken/password' = OPENSTACK_NOVA_PASSWORD;

# [neutron] section
'neutron/url' = openstack_generate_uri(
    OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL,
    OPENSTACK_NEUTRON_SERVERS,
    9696
);
'neutron/auth_url' = openstack_generate_uri(
    OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
    OPENSTACK_KEYSTONE_SERVERS,
    OPENSTACK_KEYSTONE_ADMIN_PORT
);
'neutron/auth_plugin' = 'password';
'neutron/auth_type' = 'password';
'neutron/project_domain_name' = 'default';
'neutron/user_domain_name' = 'default';
'neutron/region_name' = OPENSTACK_REGION_NAME;
'neutron/project_name' = 'service';
'neutron/username' = OPENSTACK_NEUTRON_USERNAME;
'neutron/password' = OPENSTACK_NEUTRON_PASSWORD;
'neutron/service_metadata_proxy' = 'True';
'neutron/metadata_proxy_shared_secret' = OPENSTACK_METADATA_SECRET;

# [oslo_concurrency]
'oslo_concurrency/lock_path' = '/var/lib/nova/tmp';
#[oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [placement]
'placement/os_region_name' = OPENSTACK_REGION_NAME;
'placement/project_domain_name' = 'Default';
'placement/project_name' = 'service';
'placement/auth_type' = 'password';
'placement/user_domain_name' = 'Default';
'placement/auth_url' = openstack_generate_uri(
    OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
    OPENSTACK_KEYSTONE_SERVERS,
    OPENSTACK_KEYSTONE_ADMIN_PORT
);
'placement/username' = OPENSTACK_NOVA_PLACEMENT_USER;
'placement/password' = OPENSTACK_NOVA_PLACEMENT_PASSWORD;

# [upgrade_levels]
'upgrade_levels/compute' = 'newton';

# [vnc] section
'vnc/vncserver_listen' = '$my_ip';
'vnc/vncserver_proxyclient_address' = '$my_ip';

include if (OPENSTACK_HA) {'features/nova/controller/ha'};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-nova.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/nova/controller/init-nova.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_NOVA_SERVERS),
        OPENSTACK_NOVA_USERNAME,
        OPENSTACK_NOVA_PASSWORD,
    ),
    'restart', '/root/init-nova.sh',
);
prefix '/software/components/filecopy/services';
'{/root/update-nova-to-queens.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/nova/controller/update-nova-to-queens.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
    ),
    'restart' , '/root/update-nova-to-queens.sh',
);
