template features/neutron/controller/ha;


# Configuration file for neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
'contents/DEFAULT/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
'contents/DEFAULT/dhcp_agents_per_network' = 2;
'contents/DEFAULT/allow_automatic_l3agent_failover' = 'True';
