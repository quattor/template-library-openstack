unique template machine-types/cloud/cinder-storage;

variable OPENSTACK_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/cinder/storage';
