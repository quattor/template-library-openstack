unique template features/placement/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Magnum-related type definitions
include 'types/openstack/placement';

# Include general openstack variables
include 'defaults/openstack/config';

# Install RPMs for placement
include 'features/placement/rpms';

# Configure httpd
include 'features/httpd/openstack/config';
include 'features/placement/wsgi/config';

# Configure placement section
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/placement/placement.conf}';
'module' = 'tiny';
'daemons/httpd' = 'restart';
'convert/joincomma' = true;
'convert/truefalse' = true;
bind '/software/components/metaconfig/services/{/etc/placement/placement.conf}/contents' = openstack_placement_config;

# [api] section
'contents/api/auth_strategy' = 'keystone';

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_PLACEMENT_USERNAME;
'contents/keystone_authtoken/password' = OS_PLACEMENT_PASSWORD;
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [placement] section
'contents/placement/randomize_allocation_candidates' = false;

# [placement_database] section
'contents/placement_database/connection' = format('mysql+pymysql://%s:%s@%s/placement', OS_PLACEMENT_DB_USERNAME, OS_PLACEMENT_DB_PASSWORD, OS_PLACEMENT_DB_HOST);
