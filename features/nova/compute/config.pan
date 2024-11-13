unique template features/nova/compute/config;

variable OS_NODE_SERVICES = append('nova');

# Load some useful functions
include 'defaults/openstack/functions';

# Load Nova-related type definitions
include 'types/openstack/nova';

# Include general openstack variables
include 'defaults/openstack/config';

@{
desc = template with site-specific configuration for live-migration
values = template path (namespece). Set to null to disable it.
default = undef
required = no
}
variable OS_NOVA_LIVE_MIGRATION_SITE_CONFIG ?= undef;

@{
desc = max number of files that can be opened. Must be large enough when \
       the compute server has a large number of cores, to accomodate a large \
       number of VMs
values = long
default = 32 files / physical core (e.g. 4096 on a 128 physical core machine), with a minimum = 1024 \
          taking into account the CPU ratio defined in Nova configuration
required = no
}
variable OS_NOVA_COMPUTE_MAX_FILES ?= {
    nofile = to_long(value('/hardware/cpu/0/cores') * length(value('/hardware/cpu')) * OS_NOVA_CPU_RATIO * 32);
    # 1024 is the default value, do not set a lower value
    if ( nofile  < 1024 ) {
        nofile = 1024;
    };
    nofile;
};

@{
desc = file system format to use for ephemeral devices when non specified in (image) metadata
values = string
default = ext4 (xfs has contraints of label legnth improperly handled)
required =no
}
variable OS_NOVA_DEFAULT_EPHEMERAL_FILESYSTEM ?= 'ext4';

@{
desc = default HW type per architecture
values = dict where the key is the architecture and the value the machine type
default = see variable
required = no
}
variable OS_NOVA_DEFAULT_HW_TYPE = {
    if ( is_null(SELF) ) {
        return(undef);
    };
    if ( !is_defined(SELF['x86_64']) ) {
        SELF['x86_64'] = 'q35';
    };
    SELF;
};


# Include RPMS for nova hypervisor configuration
include 'features/nova/compute/rpms';

# Include Placement configuration for compute servers
include 'features/nova/compute/placement';

# Include policy file if OS_NOVA_COMPUTE_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('nova', OS_NOVA_COMPUTE_POLICY);


# Enable nested virtualization if needed
include if ( is_defined(OS_NOVA_COMPUTE_NESTED) && OS_NOVA_COMPUTE_NESTED ) 'features/nova/compute/nested';

# Configure VM magration
include 'features/nova/compute/vm-migration/config';
# Add site-specific configuration for live migration, if any
include OS_NOVA_LIVE_MIGRATION_SITE_CONFIG;

# Restart nova and libvirt daemons
include 'components/systemd/config';
prefix '/software/components/systemd';
'unit/openstack-nova-compute/startstop' = true;
# Modular libvirt daemons and sockets
'unit' = {
    drivers = list('qemu', 'network', 'nodedev', 'nwfilter', 'secret', 'storage');
    foreach (i; drv; drivers) {
        unit_prefix = format('virt%sd', drv);
        SELF[unit_prefix] = dict(
            'startstop', false,
            'state', 'enabled',
        );
        foreach (j; socket; list('admin', 'ro')) {
            SELF[format('%s-%s', unit_prefix, socket)] = dict(
                'startstop', true,
                'type', 'socket',
            );
        };
    };
    SELF;
};

'unit/openstack-nova-compute/file/config/service/LimitNOFILE' = OS_NOVA_COMPUTE_MAX_FILES;

# Configuration file for nova
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/openstack-nova-compute' = 'restart';
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_compute_config;

# Include nova.conf configuration common to all services
include 'features/nova/common/config';

# [DEFAULT] section
'contents/DEFAULT/compute_driver' = 'libvirt.LibvirtDriver';
'contents/DEFAULT/cpu_allocation_ratio' = OS_NOVA_CPU_RATIO;
'contents/DEFAULT/default_ephemeral_format' = OS_NOVA_DEFAULT_EPHEMERAL_FILESYSTEM;
'contents/DEFAULT/initial_cpu_allocation_ratio' = OS_NOVA_INITIAL_CPU_RATIO;
'contents/DEFAULT/disk_allocation_ratio' = OS_NOVA_DISK_RATIO;
'contents/DEFAULT/initial_disk_allocation_ratio' = OS_NOVA_INITIAL_DISK_RATIO;
'contents/DEFAULT/ram_allocation_ratio' = OS_NOVA_RAM_RATIO;
'contents/DEFAULT/initial_ram_allocation_ratio' = OS_NOVA_INITIAL_RAM_RATIO;
'contents/DEFAULT/resume_guests_state_on_host_boot' = if (OS_NOVA_RESUME_VM_ON_BOOT) {
    true;
} else {
    null;
};
'contents/DEFAULT/max_concurrent_snapshots' = OS_NOVA_MAX_CONCURRENT_SNAPSHOTS;

# [cinder] section
'contents/cinder' = {
    if ( OS_CINDER_ENABLED ) {
        dict('os_region_name', OS_REGION_NAME);
    } else {
        null;
    };
};

# [libvirtd] section
'contents/libvirt/hw_machine_type' = if ( is_defined(OS_NOVA_DEFAULT_HW_TYPE) ) {
    hw_type_list = '';
    foreach (arch; hw_type; OS_NOVA_DEFAULT_HW_TYPE) {
        hw_type_list = format("%s %s=%s", hw_type_list, arch, hw_type);
    };
    replace('^\s+', '', hw_type_list);
} else {
    null;
};
'contents/libvirt/virt_type' = OS_NOVA_VIRT_TYPE;
'contents/libvirt/num_pcie_ports' = 28;

# [vnc] section
'contents/vnc/enabled' = true;
'contents/vnc/server_listen' = '0.0.0.0';
'contents/vnc/server_proxyclient_address' = PRIMARY_IP;
'contents/vnc/novncproxy_base_url' = format(
    "%s://%s:%s/vnc_lite.html",
    OS_NOVA_NOVNC_PROTOCOL,
    OS_NOVA_NOVNC_PUBLIC_HOST,
    OS_NOVA_NOVNC_PUBLIC_PORT,
);

# [workarounds] section
'contents/workarounds/skip_cpu_compare_on_dest' = ! OS_NOVA_CPU_CAPABILITIES_CHECK;

# Configure Ceph if needed
include if ( OS_NOVA_USE_CEPH ) 'features/nova/compute/ceph';
