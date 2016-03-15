unique template features/heat/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/heat/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-heat-api/on' = '';
'openstack-heat-api/startstop' = true;
'openstack-heat-api-cfn/on' = '';
'openstack-heat-api-cfn/startstop' = true;
'openstack-heat-engine/on' = '';
'openstack-heat-engine/startstop' = true;

# Configuration file for heat
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/heat/heat.conf}';
'module' = 'tiny';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/cert_file' = if (OS_SSL) {
  OS_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/key_file' = if (OS_SSL) {
  OS_SSL_KEY;
} else {
  null;
};
'contents/DEFAULT/heat_metadata_server_url'=OS_HEAT_CONTROLLER_PROTOCOL + '://' + OS_HEAT_CONTROLLER_HOST + ':8000';
'contents/DEFAULT/heat_waitcondition_server_url'=OS_HEAT_CONTROLLER_PROTOCOL + '://' + OS_HEAT_CONTROLLER_HOST + ':8000' + '/v1/waitcondition';
'contents/DEFAULT/stack_domain_admin' = OS_HEAT_USERNAME;
'contents/DEFAULT/stack_domain_admin_password' = OS_HEAT_PASSWORD;
'contents/DEFAULT/stack_user_domain_name' = OS_HEAT_STACK_DOMAIN;

# [trustee] section
'contents/trustee/auth_plugin'='password';
'contents/trustee/auth_url'=OS_HEAT_CONTROLLER_PROTOCOL + '://' + OS_HEAT_CONTROLLER_HOST + ':35357';
'contents/trustee/username'=OS_HEAT_USERNAME;
'contents/trustee/password'=OS_HEAT_PASSWORD;
'contents/trustee/user_domain_id'='default';

# [clients_keystone] section
'contents/clients_keystone/auth_url'=OS_HEAT_CONTROLLER_PROTOCOL + '://' + OS_HEAT_CONTROLLER_HOST + ':5000';

# [ec2authtoken] section
'contents/trustee/auth_url'=OS_HEAT_CONTROLLER_PROTOCOL + '://' + OS_HEAT_CONTROLLER_HOST + ':5000';

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_HEAT_DB_USERNAME + ':' +
  OS_HEAT_DB_PASSWORD + '@' +
  OS_HEAT_DB_HOST + '/heat';

  # [keystone_authtoken] section
  'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
  'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
  'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;
