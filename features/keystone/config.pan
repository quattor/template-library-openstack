
unique template features/keystone/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

include 'features/keystone/rpms/config';

# Include some useful configuration
include 'features/httpd/config';
include 'features/memcache/config';

# Configuration file for keystone
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/admin_token' ?= OPENSTACK_ADMIN_TOKEN;
'contents/DEFAULT/notification_driver' = 'messagingv2';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);

# [database] section
'contents/database/connection' = 'mysql://' +
  OPENSTACK_KEYSTONE_DB_USERNAME + ':' +
  OPENSTACK_KEYSTONE_DB_PASSWORD + '@' +
  OPENSTACK_KEYSTONE_DB_HOST +
  '/keystone';


# [memcache] section
'contents/memcache/servers' = { hosts = '';
foreach(k;v;OPENSTACK_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };
    };
    hosts;
};

# [revoke] section
'contents/revoke/driver' = 'sql';

# [token] section
'contents/token/provider' = OPENSTACK_KEYSTONE_TOKEN_PROVIDER;
'contents/token/driver' = OPENSTACK_KEYSTONE_TOKEN_DRIVER;

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# Configure identity backend
include 'features/keystone/identity/' + OPENSTACK_KEYSTONE_IDENTITY_DRIVER;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-keystone.sh}' = dict(
  'perms' ,'755',
  'config', format(
    file_contents('features/keystone/init-keystone.sh'),
    OPENSTACK_INIT_SCRIPT_GENERAL,

  ),
  'restart' , '/root/init-keystone.sh',
);
