unique template personality/neutron/network/service;

# Add RPMs
include { 'personality/neutron/network/rpms/config' };

# Configure Neutron network
include { 'personality/neutron/network/config' };
