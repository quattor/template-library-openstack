unique template features/keystone/wsgi/config;

prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/keystone.conf}';
'module' = 'openstack/wsgi-keystone';
'daemons/httpd' = 'restart';
'contents/listen' = list(5000, 35357);

'contents/vhosts/0/port' = 5000;
'contents/vhosts/0/processgroup' = 'keystone-public';
'contents/vhosts/0/script' = '/usr/bin/keystone-wsgi-public';
'contents/vhosts/0/ssl' = openstack_load_ssl_config( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' );

'contents/vhosts/1/port' = 35357;
'contents/vhosts/1/processgroup' = 'keystone-admin';
'contents/vhosts/1/script' = '/usr/bin/keystone-wsgi-admin';
'contents/vhosts/1/ssl' = openstack_load_ssl_config( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' );

# Load TT file to configure the keystone virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-keystone.tt}';
'config' = file_contents('features/keystone/wsgi/keystone.tt');
'perms' = '0644';
