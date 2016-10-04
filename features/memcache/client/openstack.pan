structure template features/memcache/client/openstack;

'memcached_servers' = { hosts = '';
foreach(k;v;OS_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };
    };
    hosts;
};
'backend' = 'oslo_cache.memcache_pool';
'enabled' = 'True';
