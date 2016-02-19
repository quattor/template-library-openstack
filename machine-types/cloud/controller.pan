unique template machine-types/cloud/controller;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'features/mariadb/config';
include 'features/rabbitmq/config';
include 'features/mongodb/config';

include 'personality/keystone/config';
include 'personality/glance/config';
include 'personality/nova/config';
include 'personality/neutron/config';
include 'features/neutron/network/config';
include 'personality/dashboard/config';
include if (OS_HEAT_ENABLED) {
    'personality/heat/config';
} else {
    null;
} ;
include if (OS_CINDER_ENABLED) {
    'personality/cinder/controller';
} else {
    null;
};
include if (OS_CEILOMETER_ENABLED) {
    'personality/ceilometer/config';
} else {
    null;
};

include 'defaults/openstack/utils';
