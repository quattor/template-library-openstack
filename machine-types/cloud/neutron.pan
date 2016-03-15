unique template machine-types/cloud/neutron;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/neutron/config';
include 'features/neutron/network/config';
