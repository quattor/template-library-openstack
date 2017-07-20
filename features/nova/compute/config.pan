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
'daemons/openstack-nova-compute'='restart';
'daemons/libvirtd'='restart';

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT/rcp_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/network_api_class' = 'nova.network.neutronv2.api.API';
'contents/DEFAULT/security_group_api' = 'neutron';
'contents/DEFAULT/linuxnet_interface_driver' = 'nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver';
'contents/DEFAULT/firewall_driver' = 'nova.virt.firewall.NoopFirewallDriver';
'contents/DEFAULT/resume_guests_state_on_host_boot' = if (OPENSTACK_NOVA_RESUME_VM_ON_BOOT) {
    'True';
} else {
    null;
};

# [glance] section
#'contents/glance/host' = openstack_get_controller_host(OPENSTACK_GLANCE_SERVERS);
#'contents/glance/protocol' = OPENSTACK_GLANCE_CONTROLLER_PROTOCOL;
'contents/glance/api_servers' = openstack_generate_uri(
    OPENSTACK_GLANCE_CONTROLLER_PROTOCOL,
    OPENSTACK_GLANCE_SERVERS,
    9292
);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_NOVA_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_NOVA_PASSWORD;

# [libvirtd] section
'contents/libvirt/virt_type' = OPENSTACK_NOVA_VIRT_TYPE;

# [neutron] section
'contents/neutron/url' = openstack_generate_uri(
    OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL,
    OPENSTACK_NEUTRON_SERVERS,
    9696
);
'contents/neutron/auth_url' = openstack_generate_uri(
    OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
    OPENSTACK_KEYSTONE_SERVERS,
    OPENSTACK_KEYSTONE_ADMIN_PORT
);
'contents/neutron/auth_plugin' = 'password';
'contents/neutron/auth_type' = 'password';
'contents/neutron/project_domain_name' = 'default';
'contents/neutron/user_domain_name' = 'default';
'contents/neutron/region_name' = OPENSTACK_REGION_NAME;
'contents/neutron/project_name' = 'service';
'contents/neutron/username' = OPENSTACK_NEUTRON_USERNAME;
'contents/neutron/password' = OPENSTACK_NEUTRON_PASSWORD;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [vnc] section
'contents/vnc/enabled' = 'True';
'contents/vnc/vncserver_listen' = '0.0.0.0';
'contents/vnc/vncserver_proxyclient_address' = '$my_ip';
'contents/vnc/novncproxy_base_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_NOVA_VNC_PROTOCOL,
        OPENSTACK_NOVA_SERVERS ,
        6080
    ),
    'vnc_auto.html'
);
'contents/vnc/xvpvncproxy_base_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_NOVA_VNC_PROTOCOL,
        OPENSTACK_NOVA_SERVERS,
        6081
    ),
    'console'
);

# [cinder] section
'contents/cinder' = {
    if (OPENSTACK_CINDER_ENABLED) {
        dict('os_region_name', OPENSTACK_REGION_NAME,
                'cinder_catalog_info','volumev2:cinderv2:publicURL',);
    } else {
        null;
    };
};

include if (OPENSTACK_CEPH_NOVA) {
        'features/nova/compute/ceph';
} else {
        null;
};
