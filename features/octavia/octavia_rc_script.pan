unique template features/octavia/octavia_rc_script;

include 'types/openstack/user_rc';

# Load TT file
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/user_rc.tt}';
'config' = file_contents('features/openstack/user_rc/user_rc.tt');
'perms' = '0644';

# Build RC file configuration
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/root/openstack-octavia-rc}';
'module' = 'openstack/user_rc';
bind '/software/components/metaconfig/services/{/root/openstack-octavia-rc}/contents' = openstack_user_rc_config;
'contents/config/OS_AUTH_URL' = format(
    '%s://%s:%s/v3',
    OS_KEYSTONE_CONTROLLER_PROTOCOL,
    OS_KEYSTONE_PUBLIC_CONTROLLER_HOST,
    OS_KEYSTONE_PUBLIC_CONTROLLER_PORT
);
'contents/config/OS_PASSWORD' = OS_OCTAVIA_PASSWORD; 
'contents/config/OS_PROJECT_DOMAIN_NAME' = 'Default'; 
'contents/config/OS_PROJECT_NAME' = 'service'; 
'contents/config/OS_USER_DOMAIN_NAME' = 'Default'; 
'contents/config/OS_USERNAME' = OS_OCTAVIA_USERNAME; 
