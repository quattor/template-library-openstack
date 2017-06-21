unique template features/cinder/storage/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/cinder/storage/rpms/config';

# Include type specific configuration
include 'features/cinder/storage/' + OPENSTACK_CINDER_STORAGE_TYPE;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-cinder-volume/on' = '';
'openstack-cinder-volume/startstop' = true;
'target/on' = '';
'target/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}/contents' = openstack_cinder_config;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
'daemons/openstack-cinder-volume' = 'restart';
# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
#'contents/DEFAULT/glance_host' = openstack_get_controller_host(OPENSTACK_GLANCE_SERVERS);
'contents/DEFAULT/glance_api_servers' = openstack_generate_uri(
    OPENSTACK_GLANCE_CONTROLLER_PROTOCOL,
    OPENSTACK_GLANCE_SERVERS,
    9292
);
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_CINDER_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_CINDER_PASSWORD;

# [database] section
'contents/database/connection' = openstack_dict_to_connection_string(OPENSTACK_CINDER_DB);

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/cinder/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');
