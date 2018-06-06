unique template features/neutron/controller/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Include utils
include 'defaults/openstack/utils';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/neutron/controller/rpms/config';

# Configure some usefull package for neutron
#include 'features/httpd/config';
#include 'features/memcache/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OPENSTACK_NEUTRON_MECHANISM + '/' + OPENSTACK_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/controller/mechanism/' + OPENSTACK_NEUTRON_MECHANISM;

# Include some common configuration
include 'features/neutron/common/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents' = openstack_neutron_config;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents';
# [DEFAULT]
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/core_plugin' = 'ml2';
'DEFAULT/service_plugins' = 'router';
'DEFAULT/allow_overlapping_ips' = 'True';
'DEFAULT/rpc_backend' = 'rabbit';
'DEFAULT/notify_nova_on_port_status_changes' = 'True';
'DEFAULT/notify_nova_on_port_data_changes' = 'True';
'DEFAULT/nova_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_NOVA_CONTROLLER_PROTOCOL,
        OPENSTACK_NOVA_SERVERS,
        8774
    ),
    'v2',
);
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT/notification_driver' = 'messagingv2';
'DEFAULT/ssl_cert_file' = if ( OPENSTACK_SSL ) {
    OPENSTACK_SSL_CERT;
} else {
    null;
};
'DEFAULT/ssl_key_file' = if ( OPENSTACK_SSL ) {
    OPENSTACK_SSL_KEY;
} else {
    null;
};
'DEFAULT/use_ssl' = if ( OPENSTACK_SSL ) {
    'True';
} else {
    null;
};

# [keystone_authtoken]
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_NEUTRON_USERNAME;
'keystone_authtoken/password' = OPENSTACK_NEUTRON_PASSWORD;

# [database]
'database/connection' = openstack_dict_to_connection_string(OPENSTACK_NEUTRON_DB);

# [nova]
'nova/auth_url' = openstack_generate_uri(
    OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
    OPENSTACK_KEYSTONE_SERVERS,
    OPENSTACK_KEYSTONE_ADMIN_PORT
);
'nova/auth_plugin' = 'password';
'nova/auth_type' = 'password';
'nova/project_domain_name' = 'default';
'nova/user_domain_name' = 'default';
'nova/region_name' = OPENSTACK_REGION_NAME;
'nova/project_name' = 'service';
'nova/username' = OPENSTACK_NOVA_USERNAME;
'nova/password' = OPENSTACK_NOVA_PASSWORD;

# [oslo_concurrency]
'oslo_concurrency/lock_path' = '/var/lib/neutron/tmp';
#[oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

include if (OPENSTACK_HA) {'features/neutron/controller/ha'};

variable OPENSTACK_NEUTRON_INIT_SCRIPT = OPENSTACK_INIT_SCRIPT_GENERAL +
    file_contents('defaults/openstack/init-network.sh');

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-neutron.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/neutron/controller/init-neutron.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
        openstack_get_controller_host(OPENSTACK_NEUTRON_SERVERS),
        OPENSTACK_NEUTRON_USERNAME,
        OPENSTACK_NEUTRON_PASSWORD,
        OPENSTACK_NEUTRON_DEFAULT_NETWORKS,
        OPENSTACK_NEUTRON_DEFAULT_DHCP_POOL['start'],
        OPENSTACK_NEUTRON_DEFAULT_DHCP_POOL['end'],
        OPENSTACK_NEUTRON_DEFAULT_GATEWAY,
        OPENSTACK_NEUTRON_DEFAULT_NAMESERVER,
    ),
    'restart' , '/root/init-neutron.sh',
);

prefix '/software/components/filecopy/services';
'{/root/update-neutron-to-ocata.sh}' = dict(
    'perms', '755',
    'config', format(
        file_contents('features/neutron/controller/update-neutron-to-ocata.sh'),
        OPENSTACK_INIT_SCRIPT_GENERAL,
    ),
    'restart' , '/root/update-neutron-to-ocata.sh',
);
