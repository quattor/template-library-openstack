unique template machine-types/cloud/keystone;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/keystone/config';

include 'defaults/openstack/utils';
