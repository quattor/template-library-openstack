
unique template features/keystone/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/keystone/rpms/config';

# Include some useful configuration
include 'features/httpd/config';
include 'features/memcache/config';

# Configuration file for keystone
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/admin_token' ?= OS_ADMIN_TOKEN;
'contents/DEFAULT/notification_driver' = 'messagingv2';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_KEYSTONE_DB_USERNAME + ':' +
  OS_KEYSTONE_DB_PASSWORD + '@' +
  OS_KEYSTONE_DB_HOST +
  '/keystone';

# [memcache] section
'contents/memcache/servers' = OS_MEMCACHE_HOST + ':11211';

# [revoke] section
'contents/revoke/driver' = 'sql';

# [token] section
'contents/token/provider' = 'uuid';
'contents/token/driver' = 'memcache';

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# Configure identity backend
include 'features/keystone/identity/' + OS_KEYSTONE_IDENTITY_DRIVER;
