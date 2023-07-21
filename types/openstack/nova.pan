# Nova-related types
declaration template types/openstack/nova;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';

@documentation {
    DEFAULT section for Nova
};
type openstack_nova_defaults = {
    include openstack_DEFAULTS

    # Resource allocation
    'cpu_allocation_ratio' ? double with SELF > 0
    'initial_cpu_allocation_ratio' ? double with SELF > 0
    'disk_allocation_ratio' ? double with SELF > 0
    'initial_disk_allocation_ratio' ? double with SELF > 0
    'instance_usage_audit' ? boolean = false
    'instance_usage_audit_period' ? choice('hour', 'day', 'month', 'year') = 'month'
    'ram_allocation_ratio' ? double with SELF > 0
    'initial_ram_allocation_ratio' ? double with SELF > 0
    'resume_guests_state_on_host_boot' : boolean = false

    # Parameters related to SSL
    'cert' ? absolute_file_path
    'key' ? absolute_file_path
    'ssl_only' : boolean = false

    # Other parameters
    'compute_monitors' ? string[]
    'enabled_apis' : string[] = list('osapi_compute', 'metadata')
    'enabled_ssl_apis' : string[] = list()
};

@documentation {
    parameters for nova configuration [api] section
}
type openstack_nova_api = {
    'dhcp_domain' : string = "novalocal"
};

@documentation {
    parameters for nova configuration [api_database] section
}
type openstack_nova_api_database = {
    'connection' : type_hostURI
};

@documentation {
    parameters for nova configuration [cinder] section
}
type openstack_nova_cinder = {
    'os_region_name': string
};

@documentation {
    parameters for nova configuration [filter_scheduler] section
}
type openstack_nova_filter_scheduler = {
    'available_filters' ? string[] = list('nova.scheduler.filters.all_filters')
    'cpu_weight_multiplier' ? double
    'disk_weight_multiplier' ? double
    'enabled_filters' ? string[]
    'ram_weight_multiplier' ? double
};

@documentation {
    parameters for nova configuration [glance] section
}
type openstack_nova_glance = {
};

@documentation {
    parameters for nova configuration [libvirt] section
}
type openstack_nova_libvirt = {
    'cpu_mode' ? string
    'disk_cachemodes' ? string[]
    'hw_disk_discard' ? choice('ignore', 'unmap')
    'images_rbd_ceph_conf' ? string
    'images_rbd_pool' ? string
    'images_type' ? choice('default', 'flat', 'lvm', 'ploop', 'qcow2', 'rbd', 'raw')
    'inject_key' ? boolean = false
    'inject_password' ? boolean = false
    'inject_partition' ? long with SELF >= -2
    'live_migration_permit_auto_converge' ? boolean
    'live_migration_permit_post_copy' ? boolean
    'virt_type' : choice('kvm', 'lxc', 'qemu', 'uml', 'parallels', 'xen')
};

@documentation {
    parameters for nova configuration [neutron] section
}
type openstack_nova_neutron = {
    'auth_url' : type_hostURI
    'auth_type' : string
    'metadata_proxy_shared_secret' ? string
    'password' : string
    'project_domain_id' ? string
    'project_domain_name' ? string
    'project_name' : string
    'region_name' ? string
    'service_metadata_proxy' : boolean = false
    'username' : string
    'user_domain_id' ? string
    'user_domain_name' ? string
} with openstack_project_name_or_id(SELF) && ( !SELF['service_metadata_proxy'] || is_defined(SELF['metadata_proxy_shared_secret']) );

@documentation {
    parameters for nova configuration [notifications] section
}
type openstack_nova_notifications = {
    'notify_on_state_change' ? choice('vm_state', 'vm_and_task_state')
};

@documentation {
  parameters for alias in [pci] section
}
type openstack_nova_pci_alias = {
    'device_type' ? choice('type-PCI', 'type-PF', 'type-VF')
    'name' ? string
    'numa_policy' ? choice('legacy', 'preferred', 'required')
    'product_id' ? string
    'vendor_id' ? string
};

@documentation {
  parameters for nova configuration [pci] section
}
type openstack_nova_pci = {
  # Unfortunately it is not possible to use openstack_nova_pci_alias as a dict is not rendered
  # properly by metaconfig tiny module
  'alias' ? string
  'passthrough_whitelist' ? string
};

@documentation {
    parameters for nova configuration [placement] section
}
type openstack_nova_placement = {
    'auth_url' : type_hostURI
    'auth_type' : string
    'os_region_name' ? string
    'password' : string
    'project_domain_id' ? string
    'project_domain_name' ? string
    'project_name' : string
    'region_name' ? string
    'user_domain_id' ? string
    'user_domain_name' ? string
    'username' : string
};

@documentation {
    parameters for nova configuration [upgrade_levels] section
}
type openstack_nova_upgrade_levels = {
    'compute' ? string
};

@documentation {
    parameters for nova configuration [uwsgi] section
}
type openstack_nova_wsgi = {
    'ssl_cert_file' ? absolute_file_path
    'ssl_key_file' ? absolute_file_path
};

@documentation {
    parameters for nova configuration [vnc] section
}
type openstack_nova_vnc = {
    'enabled' : boolean = true
    'novncproxy_base_url' ? type_hostURI
    'server_listen' ? string with is_ipv4(SELF) || is_hostname(SELF)
    'server_proxyclient_address' ? string with is_ipv4(SELF) || is_hostname(SELF)
};

@documentation {
    list of nova configuration sections common to server and compute
}
type openstack_nova_common_config = {
    'DEFAULT' : openstack_nova_defaults
    'glance' ? openstack_nova_glance
    'keystone_authtoken' : openstack_keystone_authtoken
    'neutron' ? openstack_nova_neutron
    'oslo_concurrency': openstack_oslo_concurrency
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'placement' ? openstack_nova_placement
    'upgrade_levels' ? openstack_nova_upgrade_levels
    'vnc' ? openstack_nova_vnc
};

@documentation {
    list of nova server configuration sections
}
type openstack_nova_server_config = {
    include openstack_nova_common_config
    'api' : openstack_nova_api
    'api_database' : openstack_nova_api_database
    'database' : openstack_database
    'filter_scheduler' : openstack_nova_filter_scheduler
    'pci' ? openstack_nova_pci
    'wsgi' : openstack_nova_wsgi
};

@documentation {
    list of nova configuration sections
}
type openstack_nova_compute_config = {
    include openstack_nova_common_config
    'cinder' ? openstack_nova_cinder
    'libvirt' ? openstack_nova_libvirt
    'notifications' ? openstack_nova_notifications
    'pci' ? openstack_nova_pci
};
