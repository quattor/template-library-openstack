unique template features/ceilometer/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/ceilometer/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-ceilometer-api/on' = '';
'openstack-ceilometer-api/startstop' = true;
'openstack-ceilometer-notification/on' = '';
'openstack-ceilometer-notification/startstop' = true;
'openstack-ceilometer-central/on' = '';
'openstack-ceilometer-central/startstop' = true;
'openstack-ceilometer-collector/on' = '';
'openstack-ceilometer-collector/startstop' = true;
'openstack-ceilometer-alarm-notifier/on' = '';
'openstack-ceilometer-alarm-notifier/startstop' = true;
'openstack-ceilometer-alarm-evaluator/on' = '';
'openstack-ceilometer-alarm-evaluator/startstop' = true;




# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
'daemons/openstack-ceilometer-api'='restart';
'daemons/openstack-ceilometer-notification'='restart';
'daemons/openstack-ceilometer-central'='restart';
'daemons/openstack-ceilometer-collector'='restart';
'daemons/openstack-ceilometer-alarm-evaluator'='restart';
'daemons/openstack-ceilometer-alarm-notifier'='restart';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/cert_file' = if (OS_SSL) {
  OS_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/key_file' = if (OS_SSL) {
  OS_SSL_KEY;
} else {
  null;
};

# [database] section
'contents/database/connection'='mongodb://'+ OS_CEILOMETER_DB_USERNAME + ':' + OS_CEILOMETER_DB_PASSWORD + '@' + OS_CEILOMETER_DB_HOST + ':27017/ceilometer';

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_CEILOMETER_USERNAME;
'contents/keystone_authtoken/password' = OS_CEILOMETER_PASSWORD;

'contents/service_credentials/os_auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000/v2.0';
'contents/service_credentials/username' = OS_CEILOMETER_USERNAME;
'contents/service_credentials/os_tenant_name' = 'service';
'contents/service_credentials/os_password' = OS_CEILOMETER_PASSWORD;
'contents/service_credentials/os_endpoint_type' = 'internalURL';
'contents/service_credentials/os_region_name' = OS_REGION_NAME;


include if (OS_HA) {
    'features/ceilometer/ha';
} else {
    null;
};
