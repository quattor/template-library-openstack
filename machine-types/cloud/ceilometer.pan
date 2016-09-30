unique template machine-types/cloud/ceilometer;

variable OPENSTACK_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/ceilometer/config';
