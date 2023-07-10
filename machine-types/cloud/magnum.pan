unique template machine-types/cloud/magnum;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/magnum/config';
