template machine-types/openstack/neutron;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

# Neutron server configuration
include { 'personality/neutron/server/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };
