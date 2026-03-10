unique template features/barbican/uwsgi/config;


include 'features/uwsgi/openstack/config';

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/barbican-api.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-paste_deploy.ini.tt');
'perms' = '0644';

# uwsgi configuration for Barbican API: no explicit restart needed, handled by uwsgi when config file changes
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/barbican-api.ini}';
'module' = 'openstack/barbican-api';
# Owner/group must match the one used to run the application
'group' = OS_BARBICAN_GROUP;
'owner' = OS_BARBICAN_USERNAME;
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/barbican-api.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_BARBICAN_CONTROLLER_HOST;
'contents/bind_port' = OS_BARBICAN_CONTROLLER_PORT;
'contents/config_files' = list('/etc/barbican/barbican.conf');
'contents/group' = OS_BARBICAN_GROUP;
'contents/log_file' = format("%s/api.log", OS_BARBICAN_LOG_DIR);
'contents/processes' = OS_BARBICAN_API_PROCESSES;
'contents/user' = OS_BARBICAN_USERNAME;
'contents/wsgi_file' = '/etc/barbican/barbican-api-paste.ini';
