unique template features/glance/uwsgi/config;


include 'features/uwsgi/openstack/config';

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/glance-api.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-generic.ini.tt');
'perms' = '0644';

# uwsgi configuration for Glance API: no explicit restart needed, handled by uwsgi when config file changes
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/glance-api.ini}';
'module' = 'openstack/glance-api';
# Owner/group must match the one used to run the application
'group' = OS_GLANCE_GROUP;
'owner' = OS_GLANCE_USERNAME;
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/glance-api.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_GLANCE_CONTROLLER_HOST;
'contents/bind_port' = OS_GLANCE_CONTROLLER_PORT;
'contents/config_files' = list('/etc/glance/glance.conf');
'contents/group' = OS_GLANCE_GROUP;
'contents/log_file' = format("%s/uwsgi-api.log", OS_GLANCE_LOG_DIR);
'contents/processes' = OS_GLANCE_API_PROCESSES;
'contents/threads' = 1;
'contents/user' = OS_GLANCE_USERNAME;
'contents/wsgi_file' = '/usr/bin/glance-wsgi-api';
