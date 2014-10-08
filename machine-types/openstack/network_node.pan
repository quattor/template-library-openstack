template machine-types/openstack/network_node;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

# Neutron controller configuration
include { 'personality/neutron/network/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };
