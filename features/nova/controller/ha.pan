template features/nova/controller/ha;

# Configuration file for nova
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
'contents/keystone_authtoken/memcached_servers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);

# [vnc] section
'contents/vnc/vncserver_listen' = '*';
'contents/vnc/vncserver_proxyclient_address' = '*';
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
