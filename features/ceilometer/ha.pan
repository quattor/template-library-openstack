template features/ceilometer/ha;

# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
