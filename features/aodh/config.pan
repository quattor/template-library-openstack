unique template features/aodh/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

variable OPENSTACK_AODH_USE_KOLLA_CONTAINERS ?= OPENSTACK_USE_KOLLA_CONTAINERS;
include if (OPENSTACK_AODH_USE_KOLLA_CONTAINERS) 'features/aodh/kolla/config' else 'features/aodh/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-aodh-api/on' = '';
'openstack-aodh-api/startstop' = true;
'openstack-aodh-listener/on' = '';
'openstack-aodh-listener/startstop' = true;
'openstack-aodh-evaluator/on' = '';
'openstack-aodh-evaluator/startstop' = true;
'openstack-aodh-notifier/on' = '';
'openstack-aodh-notifier/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/aodh/aodh.conf}/contents' = openstack_aodh_config;

# Configuration file for aodh
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/aodh/aodh.conf}';
'module' = 'tiny';

prefix '/software/components/metaconfig/services/{/etc/aodh/aodh.conf}/contents';
'DEFAULT/rpc_backend' = 'rabbit';
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT/my_ip' = PRIMARY_IP;
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/cert_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'DEFAULT/key_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};

# [oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_AODH_DB);
'database/connection_recycle_time' = OPENSTACK_DB_TIMEOUT;

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_AODH_USERNAME;
'keystone_authtoken/password' = OPENSTACK_AODH_PASSWORD;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-heat.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/aodh/init-aodh.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_AODH_SERVERS),
        openstack_get_controller_host(OPENSTACK_AODH_SERVERS),
        OPENSTACK_AODH_USERNAME,
        OPENSTACK_AODH_PASSWORD,
    ),
    'restart' , '/root/init-aodh.sh',
);
