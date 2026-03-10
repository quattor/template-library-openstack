unique template features/nova/controller/config;

variable OS_NODE_SERVICES = append('nova');

# Load some useful functions
include 'defaults/openstack/functions';

# Load Nova-related type definitions
include 'types/openstack/nova';

# Include general openstack variables and site configuration
include 'defaults/openstack/config';


variable OS_NOVA_SCHEDULER_ENABLED_FILTERS ?= list(
    'ComputeFilter',
    'AggregateMultiTenancyIsolation',
    'ComputeCapabilitiesFilter',
    'ImagePropertiesFilter',
    'AggregateInstanceExtraSpecsFilter',
    'ServerGroupAntiAffinityFilter',
    'ServerGroupAffinityFilter',
);

# Default availability zone for instances if none specified
# Null value keeps the default of any zone
variable OS_NOVA_DEFAULT_SCHEDULE_ZONE ?= null;

final variable OS_NOVA_API_PROCESSES ?= 20;
final variable OS_NOVA_METADATA_PROCESSES ?= 20;
final variable OS_NOVA_GROUP ?= OS_NOVA_USERNAME;


# Install RPMs for compute part of neutron
include 'features/nova/controller/rpms';

# Include policy file if OS_NOVA_CONTROLLER_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('nova', OS_NOVA_CONTROLLER_POLICY);


include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-nova-api/startstop' = true;
'openstack-nova-api/state' = 'disabled';
'openstack-nova-metadata/state' = 'disabled';
'openstack-nova-metadata/startstop' = true;
'openstack-nova-scheduler/startstop' = true;
'openstack-nova-conductor/startstop' = true;
'openstack-nova-novncproxy/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
# Do not restart services managed by uwsgi on configuration changes
'daemons/openstack-nova-conductor' = 'restart';
'daemons/openstack-nova-novncproxy' = 'restart';
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_server_config;


# Include nova.conf configuration common to all services
include 'features/nova/common/config';

# [DEFAULT] section
'contents/DEFAULT/cpu_allocation_ratio' = OS_NOVA_CPU_RATIO;
'contents/DEFAULT/default_schedule_zone' = OS_NOVA_DEFAULT_SCHEDULE_ZONE;
'contents/DEFAULT/enabled_apis' = list('osapi_compute', 'metadata');
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/osapi_compute_listen' = if ( OS_NOVA_PROTOCOL == 'https' ) {
    OS_NOVA_CONTROLLER_HOST;
} else {
    '0.0.0.0';
};
'contents/DEFAULT/osapi_compute_listen_port' = OS_NOVA_CONTROLLER_PORT;
'contents/DEFAULT/ram_allocation_ratio' = OS_NOVA_RAM_RATIO;

# [api] section
'contents/api/dhcp_domain' = OS_NEUTRON_DNS_DOMAIN;

# [api_database] section
'contents/api_database/connection' = format(
    'mysql+pymysql://%s:%s@%s/nova_api',
    OS_NOVA_DB_USERNAME,
    OS_NOVA_DB_PASSWORD,
    OS_NOVA_DB_HOST,
);

# [database] section
'contents/database/connection' = format(
    'mysql+pymysql://%s:%s@%s/nova',
    OS_NOVA_DB_USERNAME,
    OS_NOVA_DB_PASSWORD,
    OS_NOVA_DB_HOST,
);

# [filter_scheduler] section
'contents/filter_scheduler/available_filters' = list('nova.scheduler.filters.all_filters');
'contents/filter_scheduler/cpu_weight_multiplier' = OS_NOVA_CPU_WEIGHT_MULTIPLIER;
'contents/filter_scheduler/disk_weight_multiplier' = OS_NOVA_DISK_WEIGHT_MULTIPLIER;
'contents/filter_scheduler/enabled_filters' = OS_NOVA_SCHEDULER_ENABLED_FILTERS;
'contents/filter_scheduler/ram_weight_multiplier' = OS_NOVA_RAM_WEIGHT_MULTIPLIER;

# [neutron] section
'contents/neutron/metadata_proxy_shared_secret' = OS_METADATA_SECRET;
'contents/neutron/service_metadata_proxy' = true;

# Remove options not valid in the [neutron] section
'contents/neutron/auth_version' = null;
'contents/neutron/service_token_roles' = null;
'contents/neutron/service_token_roles_required' = null;
'contents/neutron/www_authenticate_uri' = null;

#[oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit/heartbeat_in_pthread' = false;

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
'contents/vnc/novncproxy_host' = OS_NOVA_NOVNC_CONTROLLER_HOST;
'contents/vnc/novncproxy_port' = OS_NOVA_NOVNC_CONTROLLER_PORT;


###################
# Configure uSWGI #
###################
include 'features/nova/controller/uwsgi/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_NOVA_PROTOCOL == 'https' ) 'features/nova/controller/nginx/config';
