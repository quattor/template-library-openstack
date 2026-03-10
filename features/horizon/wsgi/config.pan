unique template features/horizon/wsgi/config;

variable OS_HORIZON_WSGI_PROC_NUM ?= 10;
variable OS_HORIZON_WSGI_PROC_THREADS ?= 5;

include 'features/horizon/wsgi/schema';

# WSGI configuration: overwrite the httpd conf file provided by the RPM
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/openstack-dashboard.conf}';
'module' = 'openstack/wsgi-horizon';
'daemons/httpd' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/httpd/conf.d/openstack-dashboard.conf}/contents' = openstack_dashboard_httpd_config;

'contents/bind_host' = if ( OS_HORIZON_PROTOCOL == 'https' ) '127.0.0.1' else null;
'contents/port' = OS_HORIZON_INTERNAL_PORT;
'contents/wsgi/process_group' = 'horizon';
'contents/wsgi/processes' = OS_HORIZON_WSGI_PROC_NUM;
'contents/wsgi/script_path' = '/usr/share/openstack-dashboard';
'contents/wsgi/script_name' = 'openstack_dashboard/wsgi.py';
'contents/wsgi/threads' = OS_HORIZON_WSGI_PROC_THREADS;
'contents/server_name' = OS_HORIZON_HOST;
'contents/server_aliases' = if ( OS_HORIZON_HOST != FULL_HOSTNAME) {
    list(FULL_HOSTNAME);
} else {
    null;
};
'contents/root_url' = OS_HORIZON_ROOT_URL;

# Load TT file to configure the dashboard virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-horizon.tt}';
'config' = file_contents('features/horizon/wsgi/horizon.tt');
'perms' = '0644';


