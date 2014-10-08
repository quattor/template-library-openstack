# Template configuring Neutron controller

unique template personality/neutron/controller/config;

variable NEUTRON_SERVICES ?= list('neutron-server');
variable NEUTRON_NODE_TYPE ?= 'controller';

# include configuration common to client and server
include { 'personality/neutron/config' };

