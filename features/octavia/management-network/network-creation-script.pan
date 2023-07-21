# This template creates the script used to initialize the Octavia management network

unique template features/octavia/management-network/network-creation-script;

# Default value should be appropriate
variable OS_OCTAVIA_SERVER_HOSTNAME ?= OS_OCTAVIA_PUBLIC_HOST;

include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/octavia-mmgt-network-init.tt}';
'config' = file_contents('features/octavia/management-network/management-network-init.sh.tt');
'perms' = '0644';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/root/octavia-management-network-init.sh}';
'module' = 'openstack/octavia-mmgt-network-init';
'convert/truefalse' = true;
'convert/joincomma' = true;
'mode' = 0700;
bind '/software/components/metaconfig/services/{/root/octavia-management-network-init.sh}/contents' = octavia_mgt_network_config;
'contents' = dict();
'contents/mgt_port_ip_address' = OS_OCTAVIA_MGMT_NETWORK_MGT_PORT_IP;
'contents/octavia_hostname' = OS_OCTAVIA_SERVER_HOSTNAME;
'contents/internal_host' = OS_OCTAVIA_CONTROLLER_HOST;
'contents/protocol' = OS_OCTAVIA_PROTOCOL;
'contents/public_host' = OS_OCTAVIA_PUBLIC_HOST;
'contents/region_name' = OS_REGION_NAME;
'contents/subnet' = OS_OCTAVIA_MGMT_NETWORK_SUBNET;
'contents/subnet_end' = OS_OCTAVIA_MGMT_NETWORK_SUBNET_END;
'contents/subnet_start' = OS_OCTAVIA_MGMT_NETWORK_SUBNET_START;
