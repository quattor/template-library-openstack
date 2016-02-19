unique template personality/cinder/controller;

include 'features/cinder/controller/config';
include {
  if (OS_CEILOMETER_METERS_ENABLED) {
    'features/ceilometer/meters/cinder';
  } else {
    null;
  };
};
