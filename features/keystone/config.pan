unique template features/keystone/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Keystone-related type definitions
include 'types/openstack/keystone';

# Include general openstack variables
include 'defaults/openstack/config';

include 'features/keystone/rpms';

#  httpd configuration
include 'features/httpd/openstack/config';
include 'features/keystone/wsgi/config';

# memcache configuration
include 'features/memcache/config';

# Configuration file for keystone
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}/contents' = openstack_keystone_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = openstack_load_ssl_config( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' );
'contents/DEFAULT/admin_token' ?= OS_ADMIN_TOKEN;
# Remove unsupported parameters
'contents/DEFAULT/auth_strategy' = null;

# [cache] section
'contents/cache/memcache_servers' = list(OS_MEMCACHE_HOST + ':11211');
'contents/cache/enabled' = true;
'contents/cache/backend' = 'oslo_cache.memcache_pool';

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/keystone', OS_KEYSTONE_DB_USERNAME, OS_KEYSTONE_DB_PASSWORD, OS_KEYSTONE_DB_HOST);

# [fernet_tokens] section
'contents/fernet_tokens/key_repository' = '/etc/keystone/fernet-keys';

# [memcache] section
'contents/memcache/servers' = list(OS_MEMCACHE_HOST + ':11211');

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [token] section
'contents/token/provider' = 'fernet';

# Configure identity backend
include 'features/keystone/identity/' + OS_KEYSTONE_IDENTITY_DRIVER;
