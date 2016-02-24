template features/neutron/controller/ha;


# Configuration file for neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = { hosts = '';
foreach(k;v;OS_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };

        hosts;
    };
};
'contents/DEFAULT/dhcp_agents_per_network' = 2;
'contents/DEFAULT/l3_ha' = 'True';
'contents/DEFAULT/allow_automatic_l3agent_failover' = 'True';
'contents/DEFAULT/max_l3_agents_per_router' = 2;
'contents/DEFAULT/min_l3_agents_per_router' = 2;
