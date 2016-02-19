template features/cinder/storage/ceph;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';

'contents/DEFAULT/default_store' = 'ceph';
'contents/rbd/volume_driver' = 'cinder.volume.drivers.rbd.RBDDriver';
'contents/rbd/rbd_pool' = OS_CEPH_CINDER_POOL;
'contents/rbd/rbd_ceph_conf' = OS_CEPH_CINDER_CEPH_CONF;
'contents/rbd/rbd_flatten_volume_from_snapshot' = 'false';
'contents/rbd/rbd_max_clone_depth' = '5';
'contents/rbd/rbd_store_chunk_size' = '4';
'contents/rbd/rados_connect_timeout' = '-1';
'contents/DEFAULT/glance_api_version' = '2';

'contents/rbd/rbd_user' = OS_CEPH_CINDER_USER;
'contents/rbd/rbd_secret_uuid' = OS_CEPH_LIBVIRT_SECRET;

'contents/rbd/backup_driver' = 'cinder.backup.drivers.ceph';
'contents/rbd/backup_ceph_conf' = OS_CEPH_CINDER_BACKUP_CEPH_CONF;
'contents/rbd/backup_ceph_user' = OS_CEPH_CINDER_BACKUP_USER;
'contents/rbd/backup_ceph_chunk_size' = '134217728';
'contents/rbd/backup_ceph_pool' = OS_CEPH_CINDER_BACKUP_POOL;
'contents/rbd/backup_ceph_stripe_unit' = '0';
'contents/rbd/backup_ceph_stripe_count' = '0';
'contents/rbd/restore_discard_excess_bytes' = 'true';

'contents/DEFAULT/enabled_backends' = 'rbd';
