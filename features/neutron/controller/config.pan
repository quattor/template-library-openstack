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
# [DEFAULT]
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/service_plugins' = 'router';
'contents/DEFAULT/allow_overlapping_ips' = 'True';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/notify_nova_on_port_status_changes' = 'True';
'contents/DEFAULT/notify_nova_on_port_data_changes' = 'True';
'contents/DEFAULT/nova_url' = OPENSTACK_NOVA_CONTROLLER_PROTOCOL + '://' + OPENSTACK_NOVA_CONTROLLER_HOST + ':8774/v2';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/notification_driver' = 'messagingv2';
'contents/DEFAULT/ssl_cert_file' = if ( OPENSTACK_SSL ) {
  OPENSTACK_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/ssl_key_file' = if ( OPENSTACK_SSL ) {
  OPENSTACK_SSL_KEY;
} else {
  null;
};
'contents/DEFAULT/use_ssl' = if ( OPENSTACK_SSL ) {
  'True';
} else {
  null;
};

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_NEUTRON_PASSWORD;

# [database]
'contents/database/connection' = openstack_dict_to_connection_string(OPENSTACK_NEUTRON_DB);

# [nova]
'contents/nova/auth_url' = OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OPENSTACK_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/nova/auth_plugin' = 'password';
'contents/nova/auth_type' = 'password';
'contents/nova/project_domain_name' = 'default';
'contents/nova/user_domain_name' = 'default';
'contents/nova/region_name' = OPENSTACK_REGION_NAME;
'contents/nova/project_name' = 'service';
'contents/nova/username' = OPENSTACK_NOVA_USERNAME;
'contents/nova/password' = OPENSTACK_NOVA_PASSWORD;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/neutron/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

include if (OPENSTACK_HA) {
    'features/neutron/controller/ha';
} else {
    null;
};

variable OPENSTACK_NEUTRON_INIT_SCRIPT = OPENSTACK_INIT_SCRIPT_GENERAL + file_contents('defaults/openstack/init-network.sh');

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init-neutron.sh}' = dict(
  'perms' ,'755',
  'config', format(
    file_contents('features/neutron/controller/init-neutron.sh'),
    OPENSTACK_INIT_SCRIPT_GENERAL,
    OPENSTACK_NEUTRON_CONTROLLER_HOST,
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
