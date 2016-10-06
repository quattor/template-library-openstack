template features/dashboard/ha;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/openstack-dashboard/local_settings}';
'module' = 'openstack/django-horizon';
'contents/memcacheservers' = openstack_dict_to_hostport_string(OPENSTACK_MEMCACHE_HOSTS);
