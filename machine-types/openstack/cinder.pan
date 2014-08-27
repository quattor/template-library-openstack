template machine-types/openstack/cinder;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

# Cinder server configuration
include { 'personality/cinder/server/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };
