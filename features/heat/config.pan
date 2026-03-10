unique template features/heat/config;

variable OS_NODE_SERVICES = append('heat');

# Load some useful functions
include 'defaults/openstack/functions';

# Load Heat-related type definitions
include 'types/openstack/heat';

# Include general openstack variables
include 'defaults/openstack/config';

variable OS_HEAT_API_PROCESSES ?= 8;
variable OS_HEAT_GROUP ?= OS_HEAT_USERNAME;
variable OS_HEAT_LOG_DIR ?= '/var/log/heat';

# Include policy file if OS_HEAT_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('heat', OS_HEAT_POLICY);


include 'features/heat/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
# heat-api service is disabled as it is run via uwsgi
'openstack-heat-api/state' = 'disabled';
'openstack-heat-api-cfn/startstop' = true;
'openstack-heat-engine/startstop' = true;

# Configuration file for heat
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/heat/heat.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
# heat-api doesn't need to be explicitely restarted after a config change: handled by uwsgi
'daemons/openstack-heat-api-cfn' = 'restart';
'daemons/openstack-heat-engine' = 'restart';
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/heat/heat.conf}/contents' = openstack_heat_config;

# DEFAULT section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/heat_metadata_server_url' = format('%s://%s:8000', OS_HEAT_PROTOCOL, OS_HEAT_CONTROLLER_HOST);
'contents/DEFAULT/heat_waitcondition_server_url' = format(
    '%s://%s:8000/v1/waitcondition',
    OS_HEAT_PROTOCOL,
    OS_HEAT_CONTROLLER_HOST,
);
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/region_name' = openstack_add_if_defined(OS_HEAT_REGION_NAME);
'contents/DEFAULT/region_name_for_services' = openstack_add_if_defined(OS_HEAT_ENDPOINTS_REGION_NAME);
'contents/DEFAULT/rpc_response_timeout' = 120;
'contents/DEFAULT/stack_domain_admin' = OS_HEAT_DOMAIN_ADMIN_USERNAME;
'contents/DEFAULT/stack_domain_admin_password' = OS_HEAT_DOMAIN_ADMIN_PASSWORD;
'contents/DEFAULT/stack_user_domain_name' = OS_HEAT_STACK_DOMAIN;

# [clients_keystone] section
'contents/clients_keystone/auth_uri' = format(
    "%s://%s:%s",
    OS_KEYSTONE_CONTROLLER_PROTOCOL,
    OS_KEYSTONE_PUBLIC_HOST,
    OS_KEYSTONE_PUBLIC_STANDARD_PORT,
);

# [database] section
'contents/database/connection' = format(
    'mysql+pymysql://%s:%s@%s/heat',
    OS_HEAT_DB_USERNAME,
    OS_HEAT_DB_PASSWORD,
    OS_HEAT_DB_HOST,
);
'contents/database/max_pool_size' =  OS_HEAT_DB_POOL_SIZE;

# [ec2authtoken] section
'contents/ec2authtoken' = {
    SELF['auth_uri'] = if ( OS_EC2_AUTH_ENABLED ) {
        format(
            "%s://%s:%s/v3",
            OS_KEYSTONE_CONTROLLER_PROTOCOL,
            OS_KEYSTONE_PUBLIC_HOST,
            OS_KEYSTONE_PUBLIC_STANDARD_PORT,
        );
    } else {
        null;
    };
    if ( length(SELF) > 0 ) {
        SELF;
    } else {
        null;
    };
};

# [heat_api] section
'contents/heat_api/bind_port' = OS_HEAT_CONTROLLER_PORT;

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');
'contents/oslo_messaging_rabbit/heartbeat_in_pthread' = false;
'contents/oslo_messaging_rabbit/kombu_missing_consumer_retry_timeout' = 120;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_HEAT_USERNAME;
'contents/keystone_authtoken/password' = OS_HEAT_PASSWORD;

# [trustee] section
'contents/trustee/auth_type' = OS_TRUSTEE_TOKEN_AUTH_TYPE;
'contents/trustee/auth_url' = format(
    "%s://%s:%s",
    OS_KEYSTONE_CONTROLLER_PROTOCOL,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_KEYSTONE_PUBLIC_ADMIN_PORT,
);
'contents/trustee/username' = OS_HEAT_USERNAME;
'contents/trustee/password' = OS_HEAT_PASSWORD;
'contents/trustee/user_domain_id' = OS_HEAT_USER_DOMAIN;


###################
# Configure uSWGI #
###################
include 'features/heat/uwsgi/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_HEAT_PROTOCOL == 'https' ) 'features/heat/nginx/config';

