unique template features/neutron/compute/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/neutron/compute/rpms/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OS_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/compute/mechanism/' + OS_NEUTRON_MECHANISM;

# Include some common configuration
include 'features/neutron/common/config';

# Configuration file for neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

# [oslo_concurency] section
'contents/oslo_concurency/lock_path' = '/var/lib/neutron/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

