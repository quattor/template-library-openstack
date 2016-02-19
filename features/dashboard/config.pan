unique template features/dashboard/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/dashboard/rpms/config';

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/django-horizon.tt}';
'config' = file_contents('features/dashboard/metaconfig/django-horizon.tt');

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/openstack-dashboard/local_settings}';
'module' = 'django-horizon';

'daemons/httpd' = 'restart';

'contents/allowed' = OS_HORIZON_ALLOWED_HOSTS;
'contents/host' = OS_HORIZON_HOST;
'contents/role' = OS_HORIZON_DEFAULT_ROLE;
'contents/multidomain' = OS_HORIZON_MULTIDOMAIN_ENABLED;
'contents/default_domain'= OS_HORIZON_DEFAULT_DOMAIN;
'contents/keystone/protocol' = OS_KEYSTONE_CONTROLLER_PROTOCOL;
'contents/keystone/host' = OS_KEYSTONE_CONTROLLER_HOST;
'contents/keystone/api_version' = OS_HORIZON_KEYSTONE_API_VERSION;
'contents/keystone/port' = 5000;
'contents/secret_key' = OS_HORIZON_SECRET_KEY;

