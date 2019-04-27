unique template features/ceilometer/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

variable OPENSTACK_CEILOMETER_USE_KOLLA_CONTAINERS ?= OPENSTACK_USE_KOLLA_CONTAINERS;
include if (OPENSTACK_CEILOMETER_USE_KOLLA_CONTAINERS) 'features/ceilometer/kolla/config' else 'features/ceilometer/rpms/config';

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

bind '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}/contents' =
    openstack_ceilometer_config;

# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
'daemons/openstack-ceilometer-api' = 'restart';
'daemons/openstack-ceilometer-notification' = 'restart';
'daemons/openstack-ceilometer-central' = 'restart';
'daemons/openstack-ceilometer-collector' = 'restart';
'daemons/openstack-ceilometer-alarm-evaluator' = 'restart';
'daemons/openstack-ceilometer-alarm-notifier' = 'restart';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT/cert_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'contents/DEFAULT/key_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};

# [database] section
'contents/database/connection' = openstack_dict_to_connection_string(OPENSTACK_CEILOMETER_DB);
'database/connection_recycle_time' = OPENSTACK_DB_TIMEOUT;

# [oslo_messaging_rabbit] section
'contents/DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_CEILOMETER_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_CEILOMETER_PASSWORD;

'contents/service_credentials/os_auth_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
        OPENSTACK_KEYSTONE_SERVERS,
        OPENSTACK_KEYSTONE_PORT
        ),
    'v2.0'
);
'contents/service_credentials/username' = OPENSTACK_CEILOMETER_USERNAME;
'contents/service_credentials/os_tenant_name' = 'service';
'contents/service_credentials/os_password' = OPENSTACK_CEILOMETER_PASSWORD;
'contents/service_credentials/os_endpoint_type' = 'internalURL';
'contents/service_credentials/os_region_name' = OPENSTACK_REGION_NAME;

include if (OPENSTACK_HA) {'features/ceilometer/ha'};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-ceilometer.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/ceilometer/init-ceilometer.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_CEILOMETER_SERVERS),
        OPENSTACK_CEILOMETER_DB_HOST,
        OPENSTACK_CEILOMETER_DB_USERNAME,
        OPENSTACK_CEILOMETER_DB_PASSWORD,
        OPENSTACK_CEILOMETER_USERNAME,
        OPENSTACK_CEILOMETER_PASSWORD,
    ),
    'restart', '/root/init-ceilometer.sh',
);
