unique template machine-types/cloud/glance;

variable OPENSTACK_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/glance/config';
