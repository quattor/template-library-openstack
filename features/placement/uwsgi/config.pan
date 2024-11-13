unique template features/placement/uwsgi/config;


include 'features/uwsgi/openstack/config';

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/placement-api.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-generic.ini.tt');
'perms' = '0644';

# uwsgi configuration for Placement API: no explicit restart needed, handled by uwsgi when config file changes
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/placement-api.ini}';
'module' = 'openstack/placement-api';
# Owner/group must match the one used to run the application
'group' = OS_PLACEMENT_GROUP;
'owner' = OS_PLACEMENT_USERNAME;
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/placement-api.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_PLACEMENT_CONTROLLER_HOST;
'contents/bind_port' = OS_PLACEMENT_CONTROLLER_PORT;
'contents/config_files' = list('/etc/placement/placement.conf');
'contents/config_files' = list('/etc/placement/placement.conf');
'contents/group' = OS_PLACEMENT_GROUP;
'contents/log_file' = format("%s/api.log", OS_PLACEMENT_LOG_DIR);
'contents/processes' = OS_PLACEMENT_API_PROCESSES;
'contents/threads' = 1;
'contents/user' = OS_PLACEMENT_USERNAME;
'contents/wsgi_file' = '/usr/bin/placement-api';
