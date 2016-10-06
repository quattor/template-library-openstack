template features/ceilometer/ha;

# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
