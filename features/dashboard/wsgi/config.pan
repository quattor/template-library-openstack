unique template features/dashboard/wsgi/config;

include 'features/dashboard/wsgi/schema';

# WSGI configuration: overwrite the httpd conf file provided by the RPM
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/openstack-dashboard.conf}';
'module' = 'openstack/wsgi-horizon';
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/httpd/conf.d/openstack-dashboard.conf}/contents' = openstack_dashboard_httpd_config;

'contents/server_name' = OS_HORIZON_HOST;
'contents/server_aliases' = if ( OS_HORIZON_HOST != FULL_HOSTNAME) {
    list(FULL_HOSTNAME);
} else {
    null;
};
'contents/root_url' = OS_HORIZON_ROOT_URL;
'contents/ssl' = openstack_load_ssl_config( OS_HORIZON_PROTOCOL == 'https' );

# Load TT file to configure the dashboard virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-horizon.tt}';
'config' = file_contents('features/dashboard/wsgi/horizon.tt');
'perms' = '0644';


