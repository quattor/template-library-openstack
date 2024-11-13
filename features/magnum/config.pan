unique template features/magnum/config;

variable OS_NODE_SERVICES = append('magnum');

# Load some useful functions
include 'defaults/openstack/functions';

# Load Magnum-related type definitions
include 'types/openstack/magnum';

# Include general openstack variables
include 'defaults/openstack/config';

@desc{
desc = defines the cluster creation timeout (max time)
values = long
default = 60
required = no
}
variable OS_MAGNUM_CLUSTER_CREATION_TIMEOUT ?= 60;

variable OS_MAGNUM_API_PROCESSES ?= 8;
variable OS_MAGNUM_GROUP ?= OS_MAGNUM_USERNAME;
variable OS_MAGNUM_LOG_DIR ?= '/var/log/magnum';

# Include policy file if OS_MAGNUM_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('magnum', OS_MAGNUM_POLICY);


include 'features/magnum/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
# magnum-api service is disabled as it is run via uwsgi
'openstack-magnum-api/state' = 'disabled';
'openstack-magnum-conductor/startstop' = true;

# Configuration file for Magnum
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/magnum/magnum.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
# magnum-api doesn't need to be explicitely restarted after a config change: handled by uwsgi
'daemons/openstack-magnum-conductor' = 'restart';
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/magnum/magnum.conf}/contents' = openstack_magnum_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/log_dir' = OS_MAGNUM_LOG_DIR;
'contents/DEFAULT/rpc_response_timeout' = 120;

# [api] section
# When using https, the API service is access through a local Nginx proxy
'contents/api/host' = if ( OS_MAGNUM_PROTOCOL == 'https' ) {
    '127.0.0.1';
} else {
    OS_MAGNUM_CONTROLLER_HOST;
};
'contents/api/port' = OS_MAGNUM_CONTROLLER_PORT;

# [certificates] section
'contents/certificates/cert_manager_type' = 'barbican';

# [cinder] section
'contents/cinder/default_docker_volume_type' = OS_MAGNUM_DEFAULT_VOLUME_TYPE;

# [cinder_client] section
'contents/cinder_client/region_name' = OS_REGION_NAME;

# [cluster_heat] section
'contents/cluster_heat/create_timeout' = OS_MAGNUM_CLUSTER_CREATION_TIMEOUT;

# [database] section
'contents/database/connection' = format(
    'mysql+pymysql://%s:%s@%s/magnum',
    OS_MAGNUM_DB_USERNAME,
    OS_MAGNUM_DB_PASSWORD,
    OS_MAGNUM_DB_HOST,
);
'contents/database/max_pool_size' =  OS_MAGNUM_DB_POOL_SIZE;

# [heat_client] section
'contents/heat_client/region_name' = OS_HEAT_REGION_NAME;

# [keystone_auth] section
# Partial duplicate keystone_authtoken to work around a warning saying it is needed despite it seems 
# to work without it
'contents/keystone_auth' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_auth/password' = OS_MAGNUM_ADMIN_PASSWORD;
'contents/keystone_auth/username' = OS_MAGNUM_ADMIN_USERNAME;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/admin_user' = OS_MAGNUM_ADMIN_USERNAME;
'contents/keystone_authtoken/admin_password' = OS_MAGNUM_ADMIN_PASSWORD;
'contents/keystone_authtoken/admin_tenant_name' = OS_MAGNUM_ADMIN_TENANT;
'contents/keystone_authtoken/password' = OS_MAGNUM_ADMIN_PASSWORD;
'contents/keystone_authtoken/username' = OS_MAGNUM_ADMIN_USERNAME;

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');
'contents/oslo_messaging_rabbit/heartbeat_in_pthread' = false;
'contents/oslo_messaging_rabbit/kombu_missing_consumer_retry_timeout' = 120;

# [trust] section
'contents/trust/cluster_user_trust' = OS_MAGNUM_CLUSTER_USER_TRUST;
'contents/trust/trustee_domain_name' = 'magnum';
'contents/trust/trustee_domain_admin_name' = OS_MAGNUM_DOMAIN_ADMIN_USERNAME;
'contents/trust/trustee_domain_admin_password' = OS_MAGNUM_DOMAIN_ADMIN_PASSWORD;
'contents/trust/trustee_keysone_interface' = 'public';


###################
# Configure uSWGI #
###################
include 'features/magnum/uwsgi/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_MAGNUM_PROTOCOL == 'https' ) 'features/magnum/nginx/config';


################################################
# Patches to Magnum K8s initialization scripts #
# Patches must be applied manually             #
################################################
include 'features/magnum/k8s-fragment-fixes';

