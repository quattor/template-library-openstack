unique template features/heat/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

include 'features/heat/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-heat-api/on' = '';
'openstack-heat-api/startstop' = true;
'openstack-heat-api-cfn/on' = '';
'openstack-heat-api-cfn/startstop' = true;
'openstack-heat-engine/on' = '';
'openstack-heat-engine/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/heat/heat.conf}/contents' = openstack_heat_config;

# Configuration file for heat
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/heat/heat.conf}';
'module' = 'tiny';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT/cert_file' = if (OPENSTACK_SSL) {
  OPENSTACK_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/key_file' = if (OPENSTACK_SSL) {
  OPENSTACK_SSL_KEY;
} else {
  null;
};
'contents/DEFAULT/heat_metadata_server_url'=OPENSTACK_HEAT_CONTROLLER_PROTOCOL + '://' + OPENSTACK_HEAT_CONTROLLER_HOST + ':8000';
'contents/DEFAULT/heat_waitcondition_server_url'=OPENSTACK_HEAT_CONTROLLER_PROTOCOL + '://' + OPENSTACK_HEAT_CONTROLLER_HOST + ':8000' + '/v1/waitcondition';
'contents/DEFAULT/stack_domain_admin' = OPENSTACK_HEAT_USERNAME;
'contents/DEFAULT/stack_domain_admin_password' = OPENSTACK_HEAT_PASSWORD;
'contents/DEFAULT/stack_user_domain_name' = OPENSTACK_HEAT_STACK_DOMAIN;

# [trustee] section
'contents/trustee/auth_plugin'='password';
'contents/trustee/auth_url'=OPENSTACK_HEAT_CONTROLLER_PROTOCOL + '://' + OPENSTACK_HEAT_CONTROLLER_HOST + ':35357';
'contents/trustee/username'=OPENSTACK_HEAT_USERNAME;
'contents/trustee/password'=OPENSTACK_HEAT_PASSWORD;
'contents/trustee/user_domain_id'='default';

# [clients_keystone] section
'contents/clients_keystone/auth_url'=OPENSTACK_HEAT_CONTROLLER_PROTOCOL + '://' + OPENSTACK_HEAT_CONTROLLER_HOST + ':5000';

# [ec2authtoken] section
'contents/trustee/auth_url'=OPENSTACK_HEAT_CONTROLLER_PROTOCOL + '://' + OPENSTACK_HEAT_CONTROLLER_HOST + ':5000';

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'contents/database/connection' = openstack_dict_to_connection_string(OPENSTACK_HEAT_DB);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_GLANCE_PASSWORD;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-heat.sh}' = dict(
  'perms' ,'755',
  'config', format(
    file_contents('features/heat/init-heat.sh'),
    OPENSTACK_INIT_SCRIPT_GENERAL,
    OPENSTACK_HEAT_CONTROLLER_HOST,
    OPENSTACK_HEAT_CONTROLLER_HOST,
    OPENSTACK_HEAT_USERNAME,
    OPENSTACK_HEAT_PASSWORD,
    OPENSTACK_HEAT_STACK_DOMAIN,
    OPENSTACK_HEAT_DOMAIN_ADMIN_USERNAME,
    OPENSTACK_HEAT_DOMAIN_ADMIN_PASSWORD,
  ),
  'restart' , '/root/init-heat.sh',
);
