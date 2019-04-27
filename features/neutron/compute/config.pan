unique template features/neutron/compute/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/neutron/compute/rpms/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OPENSTACK_NEUTRON_MECHANISM + '/' + OPENSTACK_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/compute/mechanism/' + OPENSTACK_NEUTRON_MECHANISM;

# Include some common configuration
include 'features/neutron/common/config';

bind '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents' = openstack_neutron_compute_config;

# Configuration file for neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_NEUTRON_PASSWORD;

# [oslo_concurency] section
'contents/oslo_concurency/lock_path' = '/var/lib/neutron/tmp';
#[oslo_messaging_rabbit] section
'contents/DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');
