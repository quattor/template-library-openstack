unique template features/dashboard/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/dashboard/rpms/config';

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/django-horizon.tt}';
'config' = file_contents('features/dashboard/metaconfig/django-horizon.tt');

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/openstack-dashboard/local_settings}';
'module' = 'openstack/django-horizon';

'daemons/httpd' = 'restart';

'contents/allowed' = OPENSTACK_HORIZON_ALLOWED_HOSTS;
'contents/host' = OPENSTACK_HORIZON_HOST;
'contents/role' = OPENSTACK_HORIZON_DEFAULT_ROLE;
'contents/multidomain' = OPENSTACK_HORIZON_MULTIDOMAIN_ENABLED;
'contents/default_domain'= OPENSTACK_HORIZON_DEFAULT_DOMAIN;
'contents/keystone/protocol' = OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL;
'contents/keystone/host' = OPENSTACK_KEYSTONE_CONTROLLER_HOST;
'contents/keystone/api_version' = OPENSTACK_HORIZON_KEYSTONE_API_VERSION;
'contents/keystone/port' = 5000;
'contents/secret_key' = OPENSTACK_HORIZON_SECRET_KEY;
'contents/memcacheservers' = '127.0.0.1:11211';

'contents/enable_distributed_router' =  {
  if (exists(OPENSTACK_NEUTRON_DVR_ENABLED) && OPENSTACK_NEUTRON_DVR_ENABLED) {
    'True';
  } else {
    'False';
  };
};

include if (OPENSTACK_HA) {
    'features/dashboard/ha';
} else {
    null;
};
