unique template machine-types/cloud/nova;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/nova/config';
