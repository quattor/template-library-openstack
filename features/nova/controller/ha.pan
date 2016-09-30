template features/nova/controller/ha;

# Configuration file for nova
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
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
'contents/keystone_authtoken/memcached_servers' = { hosts = '';
foreach(k;v;OPENSTACK_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };
    };
    hosts;
};

# [vnc] section
'contents/vnc/vncserver_listen' = '*';
'contents/vnc/vncserver_proxyclient_address' = '*';
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
