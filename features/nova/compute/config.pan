unique template features/nova/compute/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include RPMS for nova hypervisor configuration
include 'features/nova/compute/rpms/config';

# Restart nova specific daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'libvirtd/on' = '';
'libvirtd/startstop' = true;
'openstack-nova-compute/on' = '';
'openstack-nova-compute/startstop' = true;

bind '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents' = openstack_nova_compute_config;

# Configuration file for nova
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'daemons/openstack-nova-compute' = 'restart';
'daemons/libvirtd' = 'restart';

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';
# [DEFAULT] section
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'DEFAULT/rcp_backend' = 'rabbit';
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT/my_ip' = PRIMARY_IP;
'DEFAULT/use_neutron' = 'True';
'DEFAULT/linuxnet_interface_driver' = OPENSTACK_NOVA_LINUXNET_INTERFACE_DRIVER;
'DEFAULT/firewall_driver' = 'nova.virt.firewall.NoopFirewallDriver';
'DEFAULT/resume_guests_state_on_host_boot' = if (OPENSTACK_NOVA_RESUME_VM_ON_BOOT) {
    'True';
} else {
    null;
};

# [glance] section
#'glance/host' = openstack_get_controller_host(OPENSTACK_GLANCE_SERVERS);
#'glance/protocol' = OPENSTACK_GLANCE_CONTROLLER_PROTOCOL;
'glance/api_servers' = openstack_generate_uri(
    OPENSTACK_GLANCE_CONTROLLER_PROTOCOL,
    OPENSTACK_GLANCE_SERVERS,
    9292
);

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OPENSTACK_NOVA_USERNAME;
'keystone_authtoken/password' = OPENSTACK_NOVA_PASSWORD;

# [libvirtd] section
'libvirt/virt_type' = OPENSTACK_NOVA_VIRT_TYPE;

# [neutron] section
'neutron/url' = openstack_generate_uri(
    OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL,
    OPENSTACK_NEUTRON_SERVERS,
    9696
);
'neutron/auth_url' = openstack_generate_uri(
    OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
    OPENSTACK_KEYSTONE_SERVERS,
    OPENSTACK_KEYSTONE_ADMIN_PORT
);
'neutron/auth_plugin' = 'password';
'neutron/auth_type' = 'password';
'neutron/project_domain_name' = 'default';
'neutron/user_domain_name' = 'default';
'neutron/region_name' = OPENSTACK_REGION_NAME;
'neutron/project_name' = 'service';
'neutron/username' = OPENSTACK_NEUTRON_USERNAME;
'neutron/password' = OPENSTACK_NEUTRON_PASSWORD;

# [oslo_concurrency]
'oslo_concurrency/lock_path' = '/var/lib/nova/tmp';
#[oslo_messaging_rabbit] section
'DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');

# [placement]
'placement/os_region_name' = OPENSTACK_REGION_NAME;
'placement/project_domain_name' = 'Default';
'placement/project_name' = 'service';
'placement/auth_type' = 'password';
'placement/user_domain_name' = 'Default';
'placement/auth_url' = openstack_generate_uri(
    OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
    OPENSTACK_KEYSTONE_SERVERS,
    OPENSTACK_KEYSTONE_ADMIN_PORT
);
'placement/username' = OPENSTACK_NOVA_PLACEMENT_USER;
'placement/password' = OPENSTACK_NOVA_PLACEMENT_PASSWORD;

# [upgrade_levels]
'upgrade_levels/compute' = 'newton';

# [vnc] section
'vnc/enabled' = 'True';
'vnc/vncserver_listen' = '0.0.0.0';
'vnc/vncserver_proxyclient_address' = '$my_ip';
'vnc/novncproxy_base_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_NOVA_VNC_PROTOCOL,
        OPENSTACK_NOVA_SERVERS ,
        6080
    ),
    'vnc_auto.html'
);
'vnc/xvpvncproxy_base_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_NOVA_VNC_PROTOCOL,
        OPENSTACK_NOVA_SERVERS,
        6081
    ),
    'console'
);

# [cinder] section
'cinder' =
    if (OPENSTACK_CINDER_ENABLED) {
        dict(
            'os_region_name', OPENSTACK_REGION_NAME,
            'cinder_catalog_info', 'volumev2:cinderv2:publicURL'
        );
    } else {
        null;
    };

include if (OPENSTACK_CEPH_NOVA) {'features/nova/compute/ceph'};
