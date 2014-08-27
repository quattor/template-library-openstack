unique template personality/neutron/controller/service;

# Add RPMs
include { 'personality/neutron/controller/rpms/config' };

# Configure Neutron controller
include { 'personality/neutron/controller/config' };
