unique template features/octavia/uwsgi/config;


include 'features/uwsgi/openstack/config';

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/octavia-api.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-generic.ini.tt');
'perms' = '0644';

# uwsgi configuration for Octavia API: no explicit restart needed, handled by uwsgi when config file changes
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/octavia-api.ini}';
'module' = 'openstack/octavia-api';
# Owner/group must match the one used to run the application
'group' = OS_OCTAVIA_GROUP;
'owner' = OS_OCTAVIA_USERNAME;
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/octavia-api.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_OCTAVIA_CONTROLLER_HOST;
'contents/bind_port' = OS_OCTAVIA_API_PORT;
'contents/config_files' = list('/etc/octavia/octavia.conf');
'contents/config_files' = list('/etc/octavia/octavia.conf');
'contents/group' = OS_OCTAVIA_GROUP;
'contents/log_file' = format("%s/api.log", OS_OCTAVIA_LOG_DIR);
'contents/processes' = OS_OCTAVIA_API_PROCESSES;
'contents/threads' = 1;
'contents/user' = OS_OCTAVIA_USERNAME;
'contents/wsgi_file' = '/usr/bin/octavia-wsgi';
