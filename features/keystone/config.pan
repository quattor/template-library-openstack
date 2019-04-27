
unique template features/keystone/config;

include 'defaults/openstack/schema/schema';

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

bind '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}/contents' = openstack_keystone_config;

prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';

prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}/contents';
# [DEFAULT] section
'DEFAULT/admin_token' ?= OPENSTACK_ADMIN_TOKEN;
'DEFAULT/notification_driver' = 'messagingv2';
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_KEYSTONE_DB);

# [memcache] section
'memcache/servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);

# [revoke] section
'revoke/driver' = 'sql';

# [token] section
'token/provider' = OPENSTACK_KEYSTONE_TOKEN_PROVIDER;
'token/driver' = OPENSTACK_KEYSTONE_TOKEN_DRIVER;

# [oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# Configure identity backend
include 'features/keystone/identity/' + OPENSTACK_KEYSTONE_IDENTITY_DRIVER;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-keystone.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/keystone/init-keystone.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,

    ),
    'restart' , '/root/init-keystone.sh',
);

prefix '/software/components/filecopy/services';
'{/root/update-keystone-to-ocata.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/keystone/update-keystone-to-ocata.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,

    ),
    'restart' , '/root/update-keystone-to-ocata.sh',
);
