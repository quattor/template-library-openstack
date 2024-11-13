unique template features/placement/config;

variable OS_NODE_SERVICES = append('placement');

variable OS_PLACEMENT_API_PROCESSES ?= 8;
variable OS_PLACEMENT_GROUP ?= OS_PLACEMENT_USERNAME;
variable OS_PLACEMENT_LOG_DIR ?= '/var/log/placement';

# Load some useful functions
include 'defaults/openstack/functions';

# Load Magnum-related type definitions
include 'types/openstack/placement';

# Include general openstack variables
include 'defaults/openstack/config';

# Include policy file if OS_PLACEMENT_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('placement', OS_PLACEMENT_POLICY);


# Install RPMs for placement
include 'features/placement/rpms';

# Configure placement section
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/placement/placement.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/placement/placement.conf}/contents' = openstack_placement_config;

# [api] section
'contents/api/auth_strategy' = 'keystone';

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_PLACEMENT_USERNAME;
'contents/keystone_authtoken/password' = OS_PLACEMENT_PASSWORD;

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [placement] section
'contents/placement/randomize_allocation_candidates' = false;

# [placement_database] section
'contents/placement_database/connection' = format(
    'mysql+pymysql://%s:%s@%s/placement',
    OS_PLACEMENT_DB_USERNAME,
    OS_PLACEMENT_DB_PASSWORD,
    OS_PLACEMENT_DB_HOST
);

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');
'contents/oslo_messaging_rabbit/heartbeat_in_pthread' = false;

###################
# Configure uSWGI #
###################
include 'features/placement/uwsgi/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_PLACEMENT_PROTOCOL == 'https' ) 'features/placement/nginx/config';


