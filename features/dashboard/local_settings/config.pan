unique template features/dashboard/local_settings/config;

include 'defaults/openstack/functions';

include 'features/dashboard/local_settings/schema';

# Load TT file to configure the dashboard configuration file
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/django-horizon.tt}';
'config' = file_contents('features/dashboard/local_settings/django-horizon.tt');

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/openstack-dashboard/local_settings}';
'module' = 'openstack/django-horizon';
'convert/joincomma' = true;
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/openstack-dashboard/local_settings}/contents' = openstack_dashboard_django_config;

'contents/allowed_hosts' = OS_HORIZON_ALLOWED_HOSTS;
'contents/cloud_timezone' = OS_CLOUD_TIMEZONE;
'contents/keystone/default_domain'= OS_HORIZON_DEFAULT_DOMAIN;
'contents/keystone/multidomain' = OS_HORIZON_MULTIDOMAIN_ENABLED;
'contents/keystone/protocol' = OS_KEYSTONE_CONTROLLER_PROTOCOL;
'contents/keystone/host' = OS_KEYSTONE_PUBLIC_CONTROLLER_HOST;
'contents/keystone/api_version' = OS_HORIZON_KEYSTONE_API_VERSION;
'contents/keystone/port' = 5000;
'contents/launch_instance' = if ( is_defined(OS_HORIZON_LAUNCH_INSTANCE) ) {
    foreach (k; v; OS_HORIZON_LAUNCH_INSTANCE) {
        SELF[k] = v;
    };
    SELF;
} else {
    dict();
};
'contents/policy_files_path' = if ( is_defined(OS_HORIZON_POLICY_FILE_PATH) ) {
    OS_HORIZON_POLICY_FILE_PATH;
} else {
    null;
};
'contents/role' = OS_HORIZON_DEFAULT_ROLE;
'contents/root_url' = OS_HORIZON_ROOT_URL;
'contents/secret_key' = OS_HORIZON_SECRET_KEY;
