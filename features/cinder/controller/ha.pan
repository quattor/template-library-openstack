template features/cinder/controller/ha;


# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/cache' = openstack_load_config('features/memcache/client/openstack');
