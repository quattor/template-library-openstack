unique template features/nova/controller/uwsgi/config;


include 'features/uwsgi/openstack/config';


############
# nova-api #
############

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/nova-api.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-generic.ini.tt');
'perms' = '0644';

# uwsgi configuration for Nova API: no explicit restart needed, handled by uwsgi when config file changes
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/nova-api.ini}';
'module' = 'openstack/nova-api';
# Owner/group must match the one used to run the application
'group' = OS_NOVA_GROUP;
'owner' = OS_NOVA_USERNAME;
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/nova-api.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_NOVA_CONTROLLER_HOST;
'contents/bind_port' = OS_NOVA_CONTROLLER_PORT;
'contents/config_files' = list('/etc/nova/nova.conf');
'contents/config_files' = list('/etc/nova/nova.conf');
'contents/group' = OS_NOVA_GROUP;
'contents/log_file' = format("%s/uwsgi-api.log", OS_NOVA_LOG_DIR);
'contents/processes' = OS_NOVA_API_PROCESSES;
'contents/threads' = 1;
'contents/user' = OS_NOVA_USERNAME;
'contents/wsgi_file' = '/usr/bin/nova-api-wsgi';


#################
# nova-metadata #
#################

# Load TT file to configure uwsgi application
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/nova-metadata.tt}';
'config' = file_contents('features/uwsgi/openstack/vassal-generic.ini.tt');
'perms' = '0644';

# uwsgi configuration for Nova metadata service: no explicit restart needed, handled by uwsgi when config file changes
prefix '/software/components/metaconfig/services/{/etc/uwsgi.d/nova-metadata.ini}';
'module' = 'openstack/nova-metadata';
# Owner/group must match the one used to run the application
'group' = OS_NOVA_GROUP;
'owner' = OS_NOVA_USERNAME;
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/uwsgi.d/nova-metadata.ini}/contents' = openstack_uwsgi_application_config;

'contents/bind_host' = OS_NOVA_CONTROLLER_HOST;
'contents/bind_port' = OS_NOVA_METADATA_PORT;
'contents/config_files' = list('/etc/nova/nova.conf');
'contents/config_files' = list('/etc/nova/nova.conf');
'contents/group' = OS_NOVA_GROUP;
'contents/log_file' = format("%s/uwsgi-metadata.log", OS_NOVA_LOG_DIR);
'contents/processes' = OS_NOVA_METADATA_PROCESSES;
'contents/threads' = 1;
'contents/user' = OS_NOVA_USERNAME;
'contents/wsgi_file' = '/usr/bin/nova-metadata-wsgi';
