template personality/nova/compute/config; 

variable NOVA_SERVICES ?= list('openstack-compute');

# include configuration common to client and server
include { 'personality/nova/config' };

