unique template features/dashboard/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

#  httpd configuration
include 'features/httpd/openstack/config';

# memcache configuration
include 'features/memcache/config';

include 'features/dashboard/rpms';

# local_settings configuration
include if ( OS_HORIZON_CONFIGURE_LOCAL_SETTINGS ) 'features/dashboard/local_settings/config';

# WSGI configuration: overwrite the httpd conf file provided by the RPM
include 'features/dashboard/wsgi/config';
