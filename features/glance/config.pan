unique template features/glance/config;

@{
desc = number of Glance API workers to start
values = long
default = number of cores, not capped to 8 (assume all CPUs have the same number of cores)
required = no
}
variable OS_GLANCE_WORKERS_NUM ?= length(value('/hardware/cpu')) * value('/hardware/cpu/0/cores');


# Load some useful functions
include 'defaults/openstack/functions';

# Define Glance types
include 'types/openstack/glance';

# Include general openstack variables
include 'defaults/openstack/config';

# Add Glance bae RPMs
include 'features/glance/rpms';

# Configgure Glance services
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-glance-api/startstop' = true;


#######################################
# Build configuration file for Glance #
#######################################

@{
doc = whether to enable or not copy-on-write cloning of images. Read \
documentation to ensure you understood/mitigated the security risks
values = boolean
default = false
required = no
}
variable OS_COW_IMG_CLONING_ENABLED ?= false;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/openstack-glance-api' = 'restart';
bind '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}/contents' = openstack_glance_api_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/show_image_direct_url' = OS_COW_IMG_CLONING_ENABLED;
'contents/DEFAULT/show_multiple_locations' = OS_GLANCE_MULTIPLE_LOCATIONS;
'contents/DEFAULT/workers' = OS_GLANCE_WORKERS_NUM;

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/glance', OS_GLANCE_DB_USERNAME, OS_GLANCE_DB_PASSWORD, OS_GLANCE_DB_HOST);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');

# [paste_deploy] section
'contents/paste_deploy/flavor' = 'keystone';

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [taskflow_executor] section
'contents/taskflow_executor/max_workers' = to_long(OS_GLANCE_WORKERS_NUM * 1.2);


######################
# Configure backends #
######################
include 'features/glance/store/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_GLANCE_CONTROLLER_PROTOCOL == 'https' ) 'features/glance/nginx/config';
