# Template configuring Neutron compute

unique template personality/neutron/compute/config;

variable NEUTRON_SERVICES ?= list('neutron-openvswitch-agent');
variable NEUTRON_NODE_TYPE ?= 'compute';

# include configuration common to client and server
include { 'personality/neutron/config' };
