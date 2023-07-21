unique template machine-types/cloud/placement;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/placement/config';
