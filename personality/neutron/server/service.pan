unique template personality/neutron/server/service;

# Add RPMs
include { 'personality/neutron/server/rpms/config' };

# Configure Neutron server
include { 'personality/neutron/server/config.pan' };
