unique template machine-types/cloud/heat;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/heat/config';
