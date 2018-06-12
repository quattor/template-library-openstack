unique template features/cinder/controller/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

include 'features/cinder/controller/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-cinder-api/on' = '';
'openstack-cinder-api/startstop' = true;
'openstack-cinder-scheduler/on' = '';
'openstack-cinder-scheduler/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}/contents' = openstack_cinder_config;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
'daemons/openstack-cinder-api' = 'restart';
'daemons/openstack-cinder-scheduler' = 'restart';

prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}/contents';
# [DEFAULT] section
'DEFAULT/rpc_backend' = 'rabbit';
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT/my_ip' = PRIMARY_IP;
'DEFAULT/notification_driver' = 'messagingv2';
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/ssl_cert_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'DEFAULT/ssl_key_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_CINDER_USERNAME;
'keystone_authtoken/password' = OPENSTACK_CINDER_PASSWORD;

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_CINDER_DB);

# [oslo_concurrency]
'oslo_concurrency/lock_path' = '/var/lib/cinder/tmp';
#[oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');


include if (OPENSTACK_HA) {'features/cinder/controller/ha'};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-cinder.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/cinder/controller/init-cinder.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_CINDER_SERVERS),
        openstack_get_controller_host(OPENSTACK_CINDER_SERVERS),
        OPENSTACK_CINDER_USERNAME,
        OPENSTACK_CINDER_PASSWORD,
    ),
    'restart' , '/root/init-cinder.sh',
);

prefix '/software/components/filecopy/services';
'{/root/update-cinder-to-queens.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/cinder/controller/update-cinder-to-queens.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_CINDER_SERVERS),
    ),
    'restart' , '/root/update-cinder-to-queens.sh',
);
