template machine-types/openstack/glance;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

# Glance server configuration
include { 'personality/glance/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };
