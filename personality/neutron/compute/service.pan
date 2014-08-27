unique template personality/neutron/compute/service;

# Add RPMs
include { 'personality/neutron/compute/rpms/config' };

# Configure Neutron compute
include { 'personality/neutron/compute/config' };
