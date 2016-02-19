template features/nova/compute/ceph;

include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'path', '/var/run/ceph/guests',
    'owner', 'qemu:libvirtd',
    'type', 'd',
    'perm', '0755',
  );
  SELF;
};
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'path', '/var/log/qemu',
    'owner', 'qemu:libvirtd',
    'type', 'd',
    'perm', '0755',
  );
  SELF;
};

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'contents/libvirt/images_type' = 'rbd';
'contents/libvirt/images_rbd_pool' = OS_CEPH_NOVA_POOL;
'contents/libvirt/images_rbd_ceph_conf' = OS_CEPH_NOVA_CEPH_CONF;
'contents/libvirt/disk_cachemodes'='"network=writeback"';
'contents/libvirt/rbd_user' = OS_CEPH_NOVA_USER;
'contents/libvirt/rbd_secret_uuid' = OS_CEPH_LIBVIRT_SECRET;
'contents/libvirt/inject_password' = 'false';
'contents/libvirt/inject_key' = 'false';
'contents/libvirt/inject_partition' = '-2';
'contents/libvirt/live_migration_flag' ='"VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_PERSIST_DEST,VIR_MIGRATE_TUNNELLED"';
'contents/libvirt/hw_disk_discard' = 'unmap';
