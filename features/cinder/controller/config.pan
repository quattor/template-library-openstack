unique template features/cinder/controller/config;

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

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
'daemons/openstack-cinder-api' = 'restart';
'daemons/openstack-cinder-scheduler' = 'restart';
# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/notification_driver' = 'messagingv2';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/ssl_cert_file' = if (OS_SSL) {
  OS_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/ssl_key_file' = if (OS_SSL) {
  OS_SSL_KEY;
} else {
  null;
};

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_CINDER_USERNAME;
'contents/keystone_authtoken/password' = OS_CINDER_PASSWORD;

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_CINDER_DB_USERNAME + ':' +
  OS_CINDER_DB_PASSWORD + '@' +
  OS_CINDER_DB_HOST + '/cinder';

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/cinder/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');


include if (OS_HA) {
    'features/cinder/controller/ha';
} else {
    null;
};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-cinder.sh}' = dict(
  'perms' ,'755',
  'config', format(
    file_contents('features/cinder/controller/init-cinder.sh'),
    OS_INIT_SCRIPT_GENERAL,
    OS_CINDER_CONTROLLER_HOST,
    OS_CINDER_CONTROLLER_HOST,
    OS_CINDER_USERNAME,
    OS_CINDER_PASSWORD,
  ),
  'restart' , '/root/init-cinder.sh',
);
