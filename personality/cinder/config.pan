unique template personality/cinder/config;

include 'features/cinder/config';

include 'features/memcache/config';

include if (OS_CEILOMETER_METERS_ENABLED) 'features/ceilometer/meters/cinder';
