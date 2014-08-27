unique template personality/nova/compute/service;

# Add RPMs
include { 'personality/nova/compute/rpms/config' };

# Configure Nova Compute
include { 'personality/nova/compute/config' };

