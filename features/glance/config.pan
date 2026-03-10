unique template features/glance/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Define Glance types
include 'types/openstack/glance';

# Include general openstack variables
include 'defaults/openstack/config';


@{
desc = number of Glance API workers to start
values = long
default = number of cores, not capped to 8 (assume all CPUs have the same number of cores)
required = no
}
variable OS_GLANCE_WORKERS_NUM ?= length(value('/hardware/cpu')) * value('/hardware/cpu/0/cores');


variable OS_NODE_SERVICES = append('glance');

@{
desc = log file for Glance service. If null, no log file is produced
values = path
default = /var/log/glance/api.log
required = no
}
variable OS_GLANCE_LOG_FILE ?= '/var/log/glance/api.log';

@{
desc = depredated option to show multiple locations when returning an image \
       use discouraged since Newton but no alternative yet (Yoga). Define \
       the relevant option only if defined to true.
values = boolean
default = undef
required =no
}
variable OS_GLANCE_MULTIPLE_LOCATIONS = {
    if ( is_boolean(SELF) && SELF ) {
        true;
    } else {
        null;
    };
};

variable OS_GLANCE_API_PROCESSES ?= 8;
variable OS_GLANCE_GROUP ?= OS_GLANCE_USERNAME;
variable OS_GLANCE_LOG_DIR ?= '/var/log/glance';


# Include policy file if OS_GLANCE_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('glance', OS_GLANCE_POLICY);


# Add Glance bae RPMs
include 'features/glance/rpms';

# Configgure Glance services
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-glance-api/startstop' = true;
'openstack-glance-api/state' = "disabled";


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
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}/contents' = openstack_glance_api_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/log_file' = OS_GLANCE_LOG_FILE;
'contents/DEFAULT/show_image_direct_url' = OS_COW_IMG_CLONING_ENABLED;
'contents/DEFAULT/show_multiple_locations' = OS_GLANCE_MULTIPLE_LOCATIONS;
'contents/DEFAULT/worker_self_reference_url' = format(
    '%s://%s:%s',
    OS_GLANCE_CONTROLLER_PROTOCOL,
    OS_GLANCE_CONTROLLER_HOST,
    OS_GLANCE_CONTROLLER_PORT
);
'contents/DEFAULT/workers' = OS_GLANCE_WORKERS_NUM;

# [database] section
'contents/database/connection' = format(
    'mysql+pymysql://%s:%s@%s/glance',
    OS_GLANCE_DB_USERNAME,
    OS_GLANCE_DB_PASSWORD,
    OS_GLANCE_DB_HOST
);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;

# [paste_deploy] section
'contents/paste_deploy/flavor' = 'keystone';

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');
'contents/oslo_messaging_rabbit/heartbeat_in_pthread' = false;

# [taskflow_executor] section
'contents/taskflow_executor/max_workers' = to_long(OS_GLANCE_WORKERS_NUM * 1.2);


######################
# Configure backends #
######################
include 'features/glance/store/config';


###################
# Configure uSWGI #
###################
include 'features/glance/uwsgi/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_GLANCE_CONTROLLER_PROTOCOL == 'https' ) 'features/glance/nginx/config';
