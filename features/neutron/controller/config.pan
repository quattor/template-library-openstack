unique template features/neutron/controller/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/neutron/controller/rpms/config';

# Configure some usefull package for neutron
#include 'features/httpd/config';
#include 'features/memcache/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OS_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/controller/mechanism/' + OS_NEUTRON_MECHANISM;

# Include some common configuration
include 'features/neutron/common/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/service_plugins' = 'router';
'contents/DEFAULT/allow_overlapping_ips' = 'True';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/notify_nova_on_port_status_changes' = 'True';
'contents/DEFAULT/notify_nova_on_port_data_changes' = 'True';
'contents/DEFAULT/nova_url' = OS_NOVA_CONTROLLER_PROTOCOL + '://' + OS_NOVA_CONTROLLER_HOST + ':8774/v2';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/ssl_cert_file' = if ( OS_SSL ) {
  OS_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/ssl_key_file' = if ( OS_SSL ) {
  OS_SSL_KEY;
} else {
  null;
};
'contents/DEFAULT/use_ssl' = if ( OS_SSL ) {
  'True';
} else {
  null;
};

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

# [database]
'contents/database/connection' = 'mysql://' +
   OS_NEUTRON_DB_USERNAME + ':' +
   OS_NEUTRON_DB_PASSWORD + '@' +
   OS_NEUTRON_DB_HOST + '/neutron';

# [nova]
'contents/nova/auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/nova/auth_plugin' = 'password';
'contents/nova/project_domain_id' = 'default';
'contents/nova/user_domain_id' = 'default';
'contents/nova/region_name' = OS_REGION_NAME;
'contents/nova/project_name' = 'service';
'contents/nova/username' = OS_NOVA_USERNAME;
'contents/nova/password' = OS_NOVA_PASSWORD;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/neutron/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');
