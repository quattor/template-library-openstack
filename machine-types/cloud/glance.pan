unique template machine-types/cloud/glance;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/glance/config';
