unique template features/glance/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

include 'features/glance/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-glance-api/on' = '';
'openstack-glance-api/startstop' = true;
'openstack-glance-registry/on' = '';
'openstack-glance-registry/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}/contents' = openstack_glance_config;

# Configuration file for glance
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'module' = 'tiny';
'daemons/openstack-glance-api' = 'restart';

prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}/contents';
# [DEFAULT] section
'DEFAULT/notification_driver' = 'messagingv2';
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/show_multiple_locations' = OPENSTACK_GLANCE_MULTIPLE_LOCATIONS;
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
'DEFAULT/registry_client_protocol' = OPENSTACK_CONTROLLER_PROTOCOL;

#[oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_GLANCE_DB);

'glance_store/filesystem_store_datadir' = OPENSTACK_GLANCE_STORE_DIR;

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_GLANCE_USERNAME;
'keystone_authtoken/password' = OPENSTACK_GLANCE_PASSWORD;

# [paste_deploy] section
'paste_deploy/flavor' = 'keystone';

bind '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}/contents' = openstack_glance_config;

prefix '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}';
'module' = 'tiny';
#'daemons/openstack-glance-registry' = 'restart';

prefix '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}/contents';
# [DEFAULT] section
'DEFAULT/notification_driver' = 'messagingv2';
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

#[oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_GLANCE_DB);

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_GLANCE_USERNAME;
'keystone_authtoken/password' = OPENSTACK_GLANCE_PASSWORD;

# [paste_deploy] section
'paste_deploy/flavor' = 'keystone';

include if (OPENSTACK_CEPH_GLANCE) {
    'features/glance/ceph';
} else {
    'features/glance/file';
};

include if (OPENSTACK_HA) {'features/glance/ha'};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-glance.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/glance/init-glance.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_GLANCE_SERVERS),
        OPENSTACK_GLANCE_USERNAME,
        OPENSTACK_GLANCE_PASSWORD,
    ),
    'restart', '/root/init-glance.sh',
);

prefix '/software/components/filecopy/services';
'{/root/update-glance-to-ocata.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/glance/update-glance-to-ocata.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_GLANCE_SERVERS),
    ),
    'restart' , '/root/update-glance-to-ocata.sh',
);
