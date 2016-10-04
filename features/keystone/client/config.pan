structure template features/keystone/client/config;

'auth_uri' = OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OPENSTACK_KEYSTONE_CONTROLLER_HOST + ':5000';
'auth_url' = OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OPENSTACK_KEYSTONE_CONTROLLER_HOST + ':35357';
'auth_plugin' = 'password';
'project_domain_name' = 'default';
'user_domain_name' = 'default';
'project_name' = 'service';
'auth_type' = 'password';
