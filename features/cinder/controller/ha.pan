template features/cinder/controller/ha;


# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
