template features/glance/ha;


# Configuration file for glance
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'contents/cache' = openstack_load_config('features/memcache/client/openstack');

# Configuration file for glance
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
