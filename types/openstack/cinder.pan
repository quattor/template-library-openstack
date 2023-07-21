# Cinder-related types
declaration template types/openstack/cinder;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';

@documentation {
    DEFAULT section for Cinder
};
type openstack_cinder_defaults = {
    include openstack_DEFAULTS

    'enabled_backends' ? string[]
    'glance_api_servers' : type_hostURI[]
    'osapi_volume_listen_port' ? long(1..65535)
    'public_endpoint' ? type_hostURI
};

@documentation {
    Paramaters for Cinder backend_defaults section
}
type openstack_cinder_backend_defaults = {
    'backup_ceph_chunk_size' ? long = 134217728
    'backup_ceph_conf' ? absolute_file_path = '/etc/ceph/ceph.conf'
    'backup_ceph_pool' ? string = 'backups'
    'backup_ceph_stripe_count' ? long = 0
    'backup_ceph_stripe_unit' ? long = 0
    'backup_ceph_user' ? string = 'cinder'
    'backup_driver' ? string = 'cinder.backup.drivers.swift.SwiftBackupDriver'
    'rados_connect_timeout' ? long = -1
    'rbd_ceph_conf' ? absolute_file_path = '/etc/ceph/ceph.conf'
    'rbd_exclusive_cinder_pool' ? boolean = false
    'rbd_flatten_volume_from_snapshot' ? boolean 
    'rbd_max_clone_depth' ? long = 5
    'rbd_pool' ? string = 'rbd'
    'rbd_secret_uuid' ?  string
    'rbd_store_chunk_size' ? long = 4
    'restore_discard_excess_bytes' ? boolean = true
    'target_protocol' ? choice('iscsi', 'iser')
    'target_helper' ? choice('fake', 'ietadm', 'iscsictl', 'lioadm', 'nvmet', 'scsiAdmin', 'spdk-nvmeof', 'tgtadm')
    'volume_driver' ? string = 'cinder.volume.drivers.lvm.LVMVolumeDriver'
};

# openstack_cinder_config needs to be extensible as there is one section
# per backend whose name is not known in advance
@documentation {
    list of cinder configuration sections
}
type openstack_cinder_config = extensible {
    'DEFAULT' : openstack_cinder_defaults
    'backend_defaults' ? openstack_cinder_backend_defaults
    'database' : openstack_database
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_concurrency' ? openstack_oslo_concurrency
    'oslo_messaging_notifications' : openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
};
