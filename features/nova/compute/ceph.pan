template features/nova/compute/ceph;

include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = append(dict(
    'path', '/var/run/ceph/guests',
    'owner', 'qemu:libvirt',
    'type', 'd',
    'perm', '0755',
));

prefix '/software/components/dirperm';
'paths' = append(dict(
    'path', '/var/log/qemu',
    'owner', 'qemu:libvirt',
    'type', 'd',
    'perm', '0755',
));

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents/libvirt';
'images_type' = 'rbd';
'images_rbd_pool' = OPENSTACK_CEPH_NOVA_POOL;
'images_rbd_ceph_conf' = OPENSTACK_CEPH_NOVA_CEPH_CONF;
'disk_cachemodes' = '"network=writethrough"';
'rbd_user' = OPENSTACK_CEPH_NOVA_USER;
'rbd_secret_uuid' = OPENSTACK_CEPH_LIBVIRT_SECRET;
'inject_password' = 'false';
'inject_key' = 'false';
'inject_partition' = '-2';
'live_migration_flag' = '"VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,' +
    'VIR_MIGRATE_LIVE,VIR_MIGRATE_PERSIST_DEST,VIR_MIGRATE_TUNNELLED"';
'hw_disk_discard' = 'unmap';
