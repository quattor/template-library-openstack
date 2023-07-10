unique template features/placement/wsgi/config;

include 'features/placement/wsgi/schema';

# WSGI configuration: overwrite the httpd conf file provided by the RPM
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/00-placement-api.conf}';
'module' = 'openstack/wsgi-placement';
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/httpd/conf.d/00-placement-api.conf}/contents' = openstack_placement_httpd_config;

'contents/port' = OS_PLACEMENT_CONTROLLER_PORT;
'contents/ssl' = openstack_load_ssl_config( OS_PLACEMENT_CONTROLLER_PROTOCOL == 'https' );


# Load TT file to configure Placement virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-placement.tt}';
'config' = file_contents('features/placement/wsgi/placement.tt');
'perms' = '0644';


