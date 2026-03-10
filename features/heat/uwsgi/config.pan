unique template features/heat/uwsgi/config;


include 'features/uwsgi/openstack/config';

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/heat-api.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-generic.ini.tt');
'perms' = '0644';

# uwsgi configuration for Heat API: no explicit restart needed, handled by uwsgi when config file changes
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/heat-api.ini}';
'module' = 'openstack/heat-api';
# Owner/group must match the one used to run the application
'group' = OS_HEAT_GROUP;
'owner' = OS_HEAT_USERNAME;
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/heat-api.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_HEAT_CONTROLLER_HOST;
'contents/bind_port' = OS_HEAT_CONTROLLER_PORT;
'contents/config_files' = list('/etc/heat/heat.conf');
'contents/group' = OS_HEAT_GROUP;
'contents/log_file' = format("%s/heat-api.log", OS_HEAT_LOG_DIR);
'contents/processes' = OS_HEAT_API_PROCESSES;
'contents/threads' = 1;
'contents/user' = OS_HEAT_USERNAME;
'contents/wsgi_file' = '/usr/bin/heat-wsgi-api';
