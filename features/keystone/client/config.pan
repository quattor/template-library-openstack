structure template features/keystone/client/config;

'auth_url' = format('%s://%s:35357', OS_KEYSTONE_CONTROLLER_PROTOCOL, OS_KEYSTONE_CONTROLLER_HOST);
'auth_type' = OS_KEYSTONE_TOKEN_AUTH_TYPE;
'auth_version' = 'v3';
'project_domain_id' = 'default';
'user_domain_id' = 'default';
'region_name' = OS_REGION_NAME;
'project_name' = 'service';
'service_token_roles' = list('admin', 'service');
'service_token_roles_required' = true;
#'keystone_authtoken/service_token_roles_required' = 'True';
'www_authenticate_uri' = format(
    '%s://%s:%S/%s',
    OS_KEYSTONE_CONTROLLER_PROTOCOL,
    OS_KEYSTONE_PUBLIC_CONTROLLER_HOST,
    OS_KEYSTONE_PUBLIC_CONTROLLER_PORT,
    OS_KEYSTONE_VERSION,
);
