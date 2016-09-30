unique template machine-types/cloud/keystone;

variable OPENSTACK_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'features/mariadb/config';
include 'features/rabbitmq/config';

include 'personality/keystone/config';
include 'personality/dashboard/config';

include 'defaults/openstack/utils';
