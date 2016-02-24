unique template personality/nova/config;

include 'features/nova/' + OS_NODE_TYPE + '/config';
include {
  if (OS_CEILOMETER_METERS_ENABLED) {
    'features/ceilometer/meters/nova/' + OS_NODE_TYPE;
  } else {
    null;
  };
};
