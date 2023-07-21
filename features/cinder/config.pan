unique template features/cinder/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Define Cinder types
include 'types/openstack/cinder';

# Include general openstack variables
include 'defaults/openstack/config';

# Load Cinder RPMs
include 'features/cinder/rpms';

# Configure services
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-cinder-api/startstop' = true;
'openstack-cinder-scheduler/startstop' = true;
'openstack-cinder-volume/startstop' = true;

# cinder.conf configuration common to all Cinder variants
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
'convert/truefalse' = true;
'convert/joincomma' = true;
'daemons/openstack-cinder-api' = 'restart';
'daemons/openstack-cinder-scheduler' = 'restart';
'daemons/openstack-cinder-volume' = 'restart';
bind '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}/contents' = openstack_cinder_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/glance_api_servers' = list(format('%s://%s:%s', OS_GLANCE_CONTROLLER_PROTOCOL, OS_GLANCE_PUBLIC_HOST, OS_GLANCE_PUBLIC_PORT));

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/cinder', OS_CINDER_DB_USERNAME, OS_CINDER_DB_PASSWORD, OS_CINDER_DB_HOST);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');
'contents/keystone_authtoken/username' = OS_CINDER_USERNAME;
'contents/keystone_authtoken/password' = OS_CINDER_PASSWORD;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/cinder/tmp';

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');


# Configure Cinder backends
include 'features/cinder/backend/config';

# Configure SSL proxy if SSL is enabled #
include if ( OS_CINDER_CONTROLLER_PROTOCOL == 'https' ) 'features/cinder/nginx/config';

# Configure Cinder backup
include if ( OS_CINDER_BACKUP_ENABLED ) 'features/cinder/backup';
