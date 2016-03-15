unique template machine-types/cloud/ceilometer;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/ceilometer/config';
