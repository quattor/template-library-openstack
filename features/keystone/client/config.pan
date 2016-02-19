structure template features/keystone/client/config;

'auth_uri' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'auth_plugin' = 'password';
'project_domain_id' = 'default';
'user_domain_id' = 'default';
'project_name' = 'service';
