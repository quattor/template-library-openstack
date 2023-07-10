unique template machine-types/cloud/compute;

variable OS_NODE_TYPE ?= 'compute';
include 'machine-types/cloud/base';

include 'personality/nova/config';
include 'personality/neutron/config';
