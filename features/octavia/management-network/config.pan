unique template features/octavia/management-network/config;

@{
desc = BRNAME parameter for the interface service script
values = string
default = none
required = yes if Octavia runs on the Neutron server
}
variable OS_OCTAVIA_MGMT_NETWORK_BRNAME ?= if ( OS_OCTAVIA_PUBLIC_HOST == OS_NEUTRON_PUBLIC_HOST ) error(
    "%s\n%s",
    "You must define OS_OCTAVIA_MGMT_NETWORK_BRNAME with the bridge device name reported by the management",
    "network creation script. If it has not yet been created, use temporily 'brqffffffff-ff'",
);


@{
desc = VXLAN_DEVICE parameter for the interface service script
values = string
default = none
required = yes if Octavia does not run on the Neutron server
}
variable OS_OCTAVIA_MGMT_NETWORK_VXLAN_DEVICE ?= if ( OS_OCTAVIA_PUBLIC_HOST != OS_NEUTRON_PUBLIC_HOST ) error(
    "You must define OS_OCTAVIA_MGMT_NETWORK_VXLAN_DEVICE as the interface support the Octavia vxlan",
);


@{
desc = MGMT_PORT_MAC parameter for the interface service script
values = string
default = undef
required = no
}
variable OS_OCTAVIA_MGMT_NETWORK_MGMT_PORT_MAC ?= error(
    "%s\n%s",
    "You must define OS_OCTAVIA_MGMT_NETWORK_MGMT_PORT_MAC with the MAC address of the management port",
    "on the management network as reported by the creation script. If it has not yet been created, use temporily 'ff:ff:ff:ff:ff:ff'",
);


@{
desc = MGT_VLAN_ID parameter for the interface service script
values = string
default = undef
required = no
}
variable OS_OCTAVIA_MGMT_NETWORK_VLAN_ID ?= if ( OS_OCTAVIA_PUBLIC_HOST != OS_NEUTRON_PUBLIC_HOST ) error(
    "You must define OS_OCTAVIA_MGMT_NETWORK_VLAN_ID with VLAN ID of the management network (check on Neutron server)",
);


# Create interface service startup script
# Ensure that the script name used matches what is used in the service definition below
include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/opt/octavia/octavia-interface.sh}';
'config' = if ( OS_OCTAVIA_PUBLIC_HOST == OS_NEUTRON_PUBLIC_HOST ) {
    file_contents('features/octavia/management-network/octavia-neutron-interface.sh.templ');
} else {
    file_contents('features/octavia/management-network/octavia-only-interface.sh.templ');
};
'perms' = '0755';


include 'types/openstack/octavia';

include 'components/metaconfig/config';

# Load defaults for values used to configure the management network
include 'features/octavia/management-network/defaults';

# Configure octavia RC script in case the management network is not managed on the Octavia server
# (normally done on the Neutron server)
include 'features/octavia/octavia_rc_script';

# Create service
include 'defaults/openstack/functions';
include 'components/systemd/config';
'/software/components/systemd/dependencies/pre' = openstack_add_component_dependency(list('filecopy', 'metaconfig'));
'/software/components/systemd/skip/service' = false;

'/software/components/systemd/unit/octavia-interface/file/replace' = true;

prefix '/software/components/systemd/unit/octavia-interface';
'startstop' = true;

prefix '/software/components/systemd/unit/octavia-interface/file/config/unit';
'After' = list('neutron-linuxbridge-agent.service');
'Description' = 'Octavia Interface Creator';

prefix '/software/components/systemd/unit/octavia-interface/file/config/install';
'WantedBy' = list('multi-user.target');

prefix '/software/components/systemd/unit/octavia-interface/file/config/service';
'EnvironmentFile' = list('/etc/sysconfig/octavia-interface');
'ExecStart' = '/opt/octavia/octavia-interface.sh start';
'ExecStop' = '/opt/octavia/octavia-interface.sh stop';
'RemainAfterExit' = true;
'Type' = 'oneshot';


# Create service environment file
prefix '/software/components/metaconfig/services/{/etc/sysconfig/octavia-interface}';
'module' = 'tiny';
'daemons/octavia-interface' = 'restart';
bind '/software/components/metaconfig/services/{/etc/sysconfig/octavia-interface}/contents' = octavia_mgt_interface_service_config;
'contents/BRNAME' = openstack_add_if_defined(OS_OCTAVIA_MGMT_NETWORK_BRNAME);
'contents/HM_BIND_PORT' = OS_OCTAVIA_HEALTH_MANAGER_BIND_PORT;
'contents/MGMT_PORT_MAC' = openstack_add_if_defined(OS_OCTAVIA_MGMT_NETWORK_MGMT_PORT_MAC);
'contents/MGMT_VLAN_ID' = OS_OCTAVIA_MGMT_NETWORK_VLAN_ID;
'contents/VXLAN_DEVICE' = openstack_add_if_defined(OS_OCTAVIA_MGMT_NETWORK_VXLAN_DEVICE);


# Create interface definition in network service when running on the Neutron server
include if ( OS_OCTAVIA_PUBLIC_HOST == OS_NEUTRON_PUBLIC_HOST ) 'features/octavia/management_network/add_systemd_interface';

# Configure DHCP client for management network
# Note: before octavia-interface is fully configured, the service restart when the dhcp client
# configuration is changed will produce an error and a broken dependency for systemd. Just rerun the compoent
# manually to work around the error
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/dhcp-client.tt}';
'config' = file_contents('features/octavia/management-network/dhcp-client.tt');
'perms' = '0644';

prefix '/software/components/metaconfig/services/{/etc/dhcp/octavia}';
'module' = 'openstack/dhcp-client';
'convert/truefalse' = true;
'convert/joincomma' = true;
'daemons/octavia-interface' = 'restart';
bind '/software/components/metaconfig/services/{/etc/dhcp/octavia}/contents' = octavia_mgt_network_dhcp_client_config;
# Use schema defaults
'contents' = dict();


# Script to create the Octavia management network
include 'features/octavia/management-network/network-creation-script';
