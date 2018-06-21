unique template features/barbican/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

include 'features/barbican/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-barbican-api/on' = '';
'openstack-barbican-api/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/barbican/barbican.conf}/contents' = openstack_barbican_config;

# Configuration file for barbican
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/barbican/barbican.conf}';
'module' = 'tiny';
'daemons/openstack-barbican-api' = 'restart';

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

'contents/DEFAULT/sql_connection' = openstack_dict_to_connection_string(OPENSTACK_BARBICAN_DB);
'contents/DEFAULT/transport_url' = openstack_dict_to_transport_string(OPENSTACK_RABBITMQ_DICT);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_BARBICAN_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_BARBICAN_PASSWORD;
'contents/keystone_authtoken/os_project_name' = 'service';
'contents/keystone_authtoken/os_region_name' = OPENSTACK_REGION_NAME;

# [simple_crypto_plugin] section
'contents/simple_crypto_plugin/kek' = OPENSTACK_BARBICAN_KEK;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-barbican.sh}' = dict(
    'perms' ,'755',
    'config', format(
        file_contents('features/barbican/init-barbican.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_BARBICAN_SERVERS),
        OPENSTACK_BARBICAN_USERNAME,
        OPENSTACK_BARBICAN_PASSWORD,
    ),
    'restart', '/root/init-barbican.sh',
);

