template features/glance/ceph;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'contents/DEFAULT/default_store' = 'rbd';
'contents/DEFAULT/show_image_direct_url' = 'True';
# [glance_store] section
'contents/glance_store/stores' = 'rbd';
'contents/glance_store/default_store' = 'rbd';
'contents/glance_store/rbd_store_pool' = OS_CEPH_GLANCE_POOL;
'contents/glance_store/rbd_store_user' = OS_CEPH_GLANCE_USER;
'contents/glance_store/rbd_store_ceph_conf' = OS_CEPH_GLANCE_CEPH_CONF;
'contents/glance_store/rbd_store_chunk_size' = '8';
