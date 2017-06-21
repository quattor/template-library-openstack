unique template machine-types/cloud/controller;

variable OPENSTACK_NODE_TYPE ?= 'controller';
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
include if (OPENSTACK_HEAT_ENABLED) {
        'personality/heat/config';
} else {
        null;
} ;
include if (OPENSTACK_CINDER_ENABLED) {
        'personality/cinder/controller';
} else {
        null;
};
include if (OPENSTACK_CEILOMETER_ENABLED) {
        'personality/ceilometer/config';
} else {
        null;
};

include 'defaults/openstack/utils';
