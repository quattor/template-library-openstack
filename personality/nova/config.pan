unique template personality/nova/config;

include 'features/nova/' + OPENSTACK_NODE_TYPE + '/config';
include {
  if (OPENSTACK_CEILOMETER_METERS_ENABLED) {
    'features/ceilometer/meters/nova/' + OPENSTACK_NODE_TYPE;
  } else {
    null;
  };
};
