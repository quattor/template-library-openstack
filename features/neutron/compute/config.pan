unique template features/neutron/compute/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OS_NEUTRON_NETWORK_TYPE;

# Include some common configuration
include 'features/neutron/base';


################
# neutron.conf #
################

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
bind '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents' = openstack_neutron_compute_config;
