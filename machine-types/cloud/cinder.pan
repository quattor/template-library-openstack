unique template machine-types/cloud/cinder;

variable OPENSTACK_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/cinder/controller';
