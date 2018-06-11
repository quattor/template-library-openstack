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

prefix '/software/components/metaconfig/services/{/etc/heat/heat.conf}/contents';
'DEFAULT/rpc_backend' = 'rabbit';
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT/my_ip' = PRIMARY_IP;
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/cert_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'DEFAULT/key_file' = if (OPENSTACK_SSL) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};
'DEFAULT/heat_metadata_server_url' = openstack_generate_uri(
    OPENSTACK_HEAT_CONTROLLER_PROTOCOL,
    OPENSTACK_HEAT_SERVERS,
    8000
);
'DEFAULT/heat_waitcondition_server_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_HEAT_CONTROLLER_PROTOCOL,
        OPENSTACK_HEAT_SERVERS,
        8000
    ),
    'v1/waitcondition'
);
'DEFAULT/stack_domain_admin' = OPENSTACK_HEAT_USERNAME;
'DEFAULT/stack_domain_admin_password' = OPENSTACK_HEAT_PASSWORD;
'DEFAULT/stack_user_domain_name' = OPENSTACK_HEAT_STACK_DOMAIN;

# [trustee] section
'trustee/auth_plugin' = 'password';
'trustee/auth_url' = openstack_generate_uri(
    OPENSTACK_HEAT_CONTROLLER_PROTOCOL,
    OPENSTACK_HEAT_SERVERS,
    35357
);
'trustee/username' = OPENSTACK_HEAT_USERNAME;
'trustee/password' = OPENSTACK_HEAT_PASSWORD;
'trustee/user_domain_id' = 'default';

# [clients_keystone] section
'clients_keystone/auth_uri' = openstack_generate_uri(
    OPENSTACK_HEAT_CONTROLLER_PROTOCOL,
    OPENSTACK_HEAT_SERVERS,
    5000
);

# [ec2authtoken] section
'trustee/auth_uri' = openstack_generate_uri(
    OPENSTACK_HEAT_CONTROLLER_PROTOCOL,
    OPENSTACK_HEAT_SERVERS,
    5000
);

# [oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_HEAT_DB);

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_HEAT_USERNAME;
'keystone_authtoken/password' = OPENSTACK_HEAT_PASSWORD;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-heat.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/heat/init-heat.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_HEAT_SERVERS),
        openstack_get_controller_host(OPENSTACK_HEAT_SERVERS),
        OPENSTACK_HEAT_USERNAME,
        OPENSTACK_HEAT_PASSWORD,
        OPENSTACK_HEAT_STACK_DOMAIN,
        OPENSTACK_HEAT_DOMAIN_ADMIN_USERNAME,
        OPENSTACK_HEAT_DOMAIN_ADMIN_PASSWORD,
    ),
    'restart' , '/root/init-heat.sh',
);

prefix '/software/components/filecopy/services';
'{/root/update-heat-to-pike.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/heat/update-heat-to-pike.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
    ),
    'restart' , '/root/update-heat-to-pike.sh',
);
