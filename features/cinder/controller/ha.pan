template features/cinder/controller/ha;


# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = { hosts = '';
foreach(k;v;OPENSTACK_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };
    };
    hosts;
};
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
