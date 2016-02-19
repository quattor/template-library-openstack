unique template machine-types/cloud/cinder;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/cinder/controller';
