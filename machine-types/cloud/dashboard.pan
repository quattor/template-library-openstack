unique template machine-types/cloud/dashboard;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/dashboard/config';

include 'defaults/openstack/utils';
