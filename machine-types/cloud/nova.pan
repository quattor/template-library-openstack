unique template machine-types/cloud/nova;

variable OPENSTACK_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/nova/config';
