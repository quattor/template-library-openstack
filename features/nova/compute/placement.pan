unique template features/nova/compute/placement;

# Configure placement section
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';
'placement/auth_type' = 'password';
'placement/auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357/v3';
'placement/password' = OS_PLACEMENT_PASSWORD;
'placement/project_domain_name' = 'default';
'placement/project_name' = 'service';
'placement/region_name' = OS_REGION_NAME;
'placement/username' = OS_PLACEMENT_USERNAME;
'placement/user_domain_name' = 'default';

