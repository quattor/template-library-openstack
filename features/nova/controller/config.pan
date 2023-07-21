unique template features/nova/controller/config;

variable OS_NOVA_SCHEDULER_ENABLED_FILTERS ?= list(
    'AggregateInstanceExtraSpecsFilter',
    'AvailabilityZoneFilter',
    'ComputeFilter',
    'ComputeCapabilitiesFilter',
    'ImagePropertiesFilter',
    'ServerGroupAntiAffinityFilter',
    'ServerGroupAffinityFilter',
);

# Load some useful functions
include 'defaults/openstack/functions';

# Load Nova-related type definitions
include 'types/openstack/nova';

# Include general openstack variables
include 'defaults/openstack/config';

# Install RPMs for compute part of neutron
include 'features/nova/controller/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-nova-api/startstop' = true;
'openstack-nova-scheduler/startstop' = true;
'openstack-nova-conductor/startstop' = true;
'openstack-nova-novncproxy/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/openstack-nova-api'='restart';
'daemons/openstack-nova-scheduler'='restart';
'daemons/openstack-nova-conductor'='restart';
'daemons/openstack-nova-novncproxy'='restart';
bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_server_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = openstack_load_ssl_config( OS_NOVA_CONTROLLER_PROTOCOL == 'https' );
'contents/DEFAULT/cpu_allocation_ratio' = OS_NOVA_CPU_RATIO;
'contents/DEFAULT/enabled_apis' = list('osapi_compute', 'metadata');
'contents/DEFAULT/enabled_ssl_apis' = if ( OS_NOVA_CONTROLLER_PROTOCOL == 'https') {
    list('osapi_compute');
} else {
    null;
};
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/ram_allocation_ratio' = OS_NOVA_RAM_RATIO;

# Enable SSL for novnc
'contents/DEFAULT' = {
     if ( OS_NOVA_CONTROLLER_PROTOCOL == 'https' ) {
         SELF['cert'] = SELF['cert_file'];
         SELF['key'] = SELF['key_file'];
         SELF['ssl_only'] = true;
     } else {
         SELF['ssl_only'] = false;
     };
     SELF;
};

# [api] section
'contents/api/dhcp_domain' = OS_NEUTRON_DNS_DOMAIN;

# [api_database] section
'contents/api_database/connection' = format('mysql+pymysql://%s:%s@%s/nova_api', OS_NOVA_DB_USERNAME, OS_NOVA_DB_PASSWORD, OS_NOVA_DB_HOST);

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/nova', OS_NOVA_DB_USERNAME, OS_NOVA_DB_PASSWORD, OS_NOVA_DB_HOST);

# [filter_scheduler] section
'contents/filter_scheduler/available_filters' = list('nova.scheduler.filters.all_filters');
'contents/filter_scheduler/cpu_weight_multiplier' = OS_NOVA_CPU_WEIGHT_MULTIPLIER;
'contents/filter_scheduler/disk_weight_multiplier' = OS_NOVA_DISK_WEIGHT_MULTIPLIER;
'contents/filter_scheduler/enabled_filters' = OS_NOVA_SCHEDULER_ENABLED_FILTERS;
'contents/filter_scheduler/ram_weight_multiplier' = OS_NOVA_RAM_WEIGHT_MULTIPLIER;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NOVA_USERNAME;
'contents/keystone_authtoken/password' = OS_NOVA_PASSWORD;
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');

# [neutron] section
'contents/neutron' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/neutron/metadata_proxy_shared_secret' = OS_METADATA_SECRET;
'contents/neutron/password' = OS_NEUTRON_PASSWORD;
'contents/neutron/service_metadata_proxy' = true;
'contents/neutron/username' = OS_NEUTRON_USERNAME;
# Remove options not valid in the [neutron] section
'contents/neutron/auth_version' = null;
'contents/neutron/service_token_roles' = null;
'contents/neutron/service_token_roles_required' = null;
'contents/neutron/www_authenticate_uri' = null;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';

#[oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [placement] section
'contents/placement/os_region_name' = OS_REGION_NAME;
'contents/placement/project_domain_name' = 'default';
'contents/placement/project_name' = 'service';
'contents/placement/user_domain_name' = 'default';
'contents/placement/password' = OS_PLACEMENT_PASSWORD;
'contents/placement/username' = OS_PLACEMENT_USERNAME;
'contents/placement/auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357/v3';
'contents/placement/auth_type' = 'password';

# [vnc] section
'contents/vnc/server_listen' = PRIMARY_IP;
'contents/vnc/server_proxyclient_address' = PRIMARY_IP;

# [upgrade_levels] section
'contents/upgrade_levels/compute' = OS_NOVA_UPGRADE_LEVELS;

# [wsgi] section
'contents/wsgi' = openstack_load_ssl_config( OS_NOVA_CONTROLLER_PROTOCOL == 'https' );
'contents/wsgi/ssl_cert_file' = if ( exists('/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents/wsgi/cert_file') ) {
    value('/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents/wsgi/cert_file');
} else {
    null;
};
'contents/wsgi/ssl_key_file' = if ( exists('/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents/wsgi/key_file') ) {
    value('/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents/wsgi/key_file');
} else {
    null;
};
'contents/wsgi/cert_file' = null;
'contents/wsgi/key_file' = null;
