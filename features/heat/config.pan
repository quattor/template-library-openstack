unique template features/heat/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Heat-related type definitions
include 'types/openstack/heat';

# Include general openstack variables
include 'defaults/openstack/config';

include 'features/heat/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-heat-api/startstop' = true;
'openstack-heat-api-cfn/startstop' = true;
'openstack-heat-engine/startstop' = true;

# Configuration file for heat
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/heat/heat.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/openstack-heat-api' = 'restart';
'daemons/openstack-heat-api-cfn' = 'restart';
'daemons/openstack-heat-engine' = 'restart';
bind '/software/components/metaconfig/services/{/etc/heat/heat.conf}/contents' = openstack_heat_config;

# DEFAULT section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = openstack_load_ssl_config( OS_HEAT_PROTOCOL == 'https' );
'contents/DEFAULT/heat_metadata_server_url' = format('%s://%s:8000', OS_HEAT_PROTOCOL, OS_HEAT_HOST);
'contents/DEFAULT/heat_waitcondition_server_url' = format('%s://%s:8000/v1/waitcondition', OS_HEAT_PROTOCOL, OS_HEAT_HOST);
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/region_name' = if ( is_defined(OS_HEAT__REGION_NAME) ) {
    OS_HEAT_REGION_NAME;
} else {
    null;
};
'contents/DEFAULT/region_name_for_services' = if ( is_defined(OS_HEAT_ENDPOINTS_REGION_NAME) ) {
    OS_HEAT_ENDPOINTS_REGION_NAME;
} else {
    null;
};
'contents/DEFAULT/stack_domain_admin' = OS_HEAT_DOMAIN_ADMIN_USERNAME;
'contents/DEFAULT/stack_domain_admin_password' = OS_HEAT_DOMAIN_ADMIN_PASSWORD;
'contents/DEFAULT/stack_user_domain_name' = OS_HEAT_STACK_DOMAIN;

# [clients_keystone] section
'contents/clients_keystone/auth_uri' = format("%s://%s:%s", OS_KEYSTONE_CONTROLLER_PROTOCOL, OS_KEYSTONE_PUBLIC_CONTROLLER_HOST, OS_KEYSTONE_PUBLIC_CONTROLLER_PORT);

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/heat', OS_HEAT_DB_USERNAME, OS_HEAT_DB_PASSWORD, OS_HEAT_DB_HOST);

# [ec2authtoken] section
'contents/ec2authtoken' = {
    SELF['auth_uri'] = if ( OS_EC2_AUTH_ENABLED ) {
        format("%s://%s:%s/v3", OS_KEYSTONE_CONTROLLER_PROTOCOL, OS_KEYSTONE_PUBLIC_CONTROLLER_HOST, OS_KEYSTONE_PUBLIC_CONTROLLER_PORT);
    } else {
        null;
    };
    if ( length(SELF) > 0 ) {
        SELF;
    } else {
        null;
    };
};

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_HEAT_USERNAME;
'contents/keystone_authtoken/password' = OS_HEAT_PASSWORD;
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');

# [trustee] section
'contents/trustee/auth_type' = OS_TRUSTEE_TOKEN_AUTH_TYPE;
'contents/trustee/auth_url' = format("%s://%s:%s", OS_KEYSTONE_CONTROLLER_PROTOCOL, OS_KEYSTONE_CONTROLLER_HOST, OS_KEYSTONE_CONTROLLER_TOKEN_PORT);
'contents/trustee/username' = OS_HEAT_USERNAME;
'contents/trustee/password'= OS_HEAT_PASSWORD;
'contents/trustee/user_domain_id' = OS_HEAT_USER_DOMAIN;
