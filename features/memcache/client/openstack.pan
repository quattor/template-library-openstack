structure template features/memcache/client/openstack;

'memcache_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'backend' = 'oslo_cache.memcache_pool';
'enabled' = 'True';
