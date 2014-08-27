template machine-types/openstack/nova;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

# Nova scheduler configuration
include { 'personality/nova/scheduler/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };
