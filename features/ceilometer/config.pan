unique template features/ceilometer/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Ceilometer-related type definitions
include 'types/openstack/ceilometer'; 

# Include general openstack variables
include 'defaults/openstack/config';

# Add Ceilometer RPMs
include 'features/ceilometer/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-ceilometer-api/startstop' = true;
'openstack-ceilometer-notification/startstop' = true;
'openstack-ceilometer-central/startstop' = true;
'openstack-ceilometer-collector/startstop' = true;


# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
'daemons/openstack-ceilometer-api'='restart';
'daemons/openstack-ceilometer-notification'='restart';
'daemons/openstack-ceilometer-central'='restart';
'daemons/openstack-ceilometer-collector'='restart';
bind '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}/contents' = openstack_ceilometer_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = openstack_load_ssl_config( OS_CEILOMETER_CONTROLLER_PROTOCOL == 'https' );

# [database] section
'contents/database/connection' = format('mongodb://%s:%s@%s:27017/ceilometer', OS_CEILOMETER_DB_USERNAME, OS_CEILOMETER_DB_PASSWORD, OS_CEILOMETER_DB_HOST);

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_CEILOMETER_USERNAME;
'contents/keystone_authtoken/password' = OS_CEILOMETER_PASSWORD;

# [service_credentials] section
'contents/service_credentials/os_auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000/v2.0';
'contents/service_credentials/username' = OS_CEILOMETER_USERNAME;
'contents/service_credentials/os_tenant_name' = 'service';
'contents/service_credentials/os_password' = OS_CEILOMETER_PASSWORD;
'contents/service_credentials/os_endpoint_type' = 'internalURL';
'contents/service_credentials/os_region_name' = OS_REGION_NAME;
