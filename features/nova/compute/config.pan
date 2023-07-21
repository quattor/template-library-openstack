unique template features/nova/compute/config;

@{
desc = template with site-specific configuration for live-migration
values = template path (namespece). Set to null to disable it.
default = undef
required = no
}
variable OS_NOVA_LIVE_MIGRATION_SITE_CONFIG ?= undef;


# Load some useful functions
include 'defaults/openstack/functions';

# Load Nova-related type definitions
include 'types/openstack/nova';

# Include general openstack variables
include 'defaults/openstack/config';

# Include RPMS for nova hypervisor configuration
include 'features/nova/compute/rpms';

# Include Placement configuration for compute servers
include 'features/nova/compute/placement';

# Include policy.json file
include if ( OS_NOVA_OVERWRITE_DEFAULT_POLICY ) 'features/nova/compute/policy/config';

# Enable nested virtualization if needed
include if ( is_defined(OS_NOVA_COMPUTE_NESTED) && OS_NOVA_COMPUTE_NESTED ) 'features/nova/compute/nested';

# Configure VM magration
include 'features/nova/compute/vm-migration/config';
# Add site-specific configuration for live migration, if any
include OS_NOVA_LIVE_MIGRATION_SITE_CONFIG;

# Restart nova specific daemon
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'libvirtd/startstop' = true;
'openstack-nova-compute/startstop' = true;


# Configuration file for nova
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/libvirtd' = 'restart';
'daemons/openstack-nova-compute' = 'restart';
bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_compute_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/cpu_allocation_ratio' = OS_NOVA_CPU_RATIO;
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

# [cinder] section
'contents/cinder' = {
  if ( OS_CINDER_ENABLED ) {
    dict('os_region_name', OS_REGION_NAME);
  } else {
    null;
  };
};

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NOVA_USERNAME;
'contents/keystone_authtoken/password' = OS_NOVA_PASSWORD;

# [libvirtd] section
'contents/libvirt/virt_type' = OS_NOVA_VIRT_TYPE;

# [neutron] section
'contents/neutron/auth_type' = 'password';
'contents/neutron/auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/neutron/password' = OS_NEUTRON_PASSWORD;
'contents/neutron/project_name' = 'service';
'contents/neutron/project_domain_id' = 'default';
'contents/neutron/region_name' = OS_REGION_NAME;
'contents/neutron/user_domain_id' = 'default';
'contents/neutron/username' = OS_NEUTRON_USERNAME;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [upgrade_levels] section
# Require OS_NOVA_UPGRADE_LEVELS to be <= to current server version
'contents/upgrade_levels' = if ( is_defined(OS_NOVA_UPGRADE_LEVELS) ) {
    if ( OS_NOVA_UPGRADE_LEVELS <= OPENSTACK_VERSION_NAME ) {
        dict('compute', OS_NOVA_UPGRADE_LEVELS);
    } else {
        error("OS_NOVA_UPGRADE_LEVELS (%s) must be less or equal to current OpenStack version (%s)",
              OS_NOVA_UPGRADE_LEVELS,
              OS_VERSION_NAME
             );
    };
} else {
    null;
};

# [vnc] section
'contents/vnc/enabled' = true;
'contents/vnc/server_listen' = '0.0.0.0';
'contents/vnc/server_proxyclient_address' = PRIMARY_IP;
'contents/vnc/novncproxy_base_url' = OS_NOVA_VNC_PROTOCOL + '://' + OS_NOVA_VNC_HOST + ':6080/vnc_auto.html';

# Configure Ceph if needed
include if ( OS_NOVA_USE_CEPH ) 'features/nova/compute/ceph';
