template machine-types/openstack/cloud_controller;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

# Neutron client configuration
include { 'personality/neutron/clients/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };

