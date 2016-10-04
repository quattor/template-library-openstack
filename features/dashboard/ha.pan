template features/dashboard/ha;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/openstack-dashboard/local_settings}';
'module' = 'openstack/django-horizon';
'contents/memcacheservers' = { hosts = '';
foreach(k;v;OS_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ';' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };
        hosts;
    };
};
