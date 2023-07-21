# Octavia-related types
declaration template types/openstack/octavia;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';


@documentation {
    api_settings section for Octavia
}
type openstack_octavia_api_settings = {
    'bind_host' : type_ipv4 = '0.0.0.0'
    'bind_port' : type_port = 9876
};

@documentation {
    certificates section for Octavia
}
type openstack_octavia_certificates = {
    'ca_certificate' : absolute_file_path
    'ca_private_key' : absolute_file_path
    'ca_private_key_passphrase' : string with match(SELF, '^[\w\-]{32}$')
    'server_certs_key_passphrase' : string with match(SELF, '^[\w\-]{32}$')

};

@documentation {
    controller_worker section for Octavia
}
type openstack_octavia_controller_worker = {
    'amp_boot_network_list' : type_openstack_id[]
    'amp_flavor_id' : long = 200
    'amphora_driver' : choice('amphora_haproxy_rest_driver') = 'amphora_haproxy_rest_driver'
    'amp_image_owner_id' ? type_openstack_id2
    'amp_image_tag' : string = 'amphora'
    'amp_secgroup_list' : string[] = list('lb-mgmt-sec-grp')
    'amp_ssh_key_name' : string
    'client_ca' : absolute_file_path
    'compute_driver' : choice('compute_nova_driver') = 'compute_nova_driver'
    'network_driver' : choice('allowed_address_pairs_driver') = 'allowed_address_pairs_driver'
};

@documentation {
    haproxy_amphora section for Octavia
}
type openstack_octavia_haproxy_amphora = {
    'client_cert' : absolute_file_path
    'server_ca' : absolute_file_path
};


@documentation {
    health_manager section for Octavia
}
type openstack_octavia_health_manager = {
    'bind_port' : type_port = 5555
    'bind_ip' : type_hostport = '172.16.0.2'
    'controller_ip_port_list' : type_ip_port[] = list('172.16.0.2:5555')
    'heartbeat_key' : string with length(SELF) >= 20
};


@documentation {
    list of octavia configuration sections
}
type openstack_octavia_config = {
    'DEFAULT' : openstack_DEFAULTS
    'api_settings' : openstack_octavia_api_settings
    'certificates' : openstack_octavia_certificates
    'controller_worker' : openstack_octavia_controller_worker
    'database' : openstack_database
    'haproxy_amphora' : openstack_octavia_haproxy_amphora
    'health_manager' : openstack_octavia_health_manager
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_messaging' : openstack_oslo_messaging
    'oslo_messaging_notifications' : openstack_oslo_messaging_notifications
    'service_auth' : openstack_keystone_authtoken
};


################################################################
# Octavia management interface service environment file schema #
################################################################

type octavia_mgt_interface_service_config = {
    'BRNAME' ? string with match (SELF, '^brq[0-9a-f\-]{8}\-[0-9a-f\-]{2}$')
    'HM_BIND_PORT' : type_port
    'MGMT_PORT_MAC' : type_hwaddr
    'MGMT_VLAN_ID' ? long(1..)
    'VXLAN_DEVICE' ? string
};


###########################################################
# Octavia management interface schema for network service #
###########################################################

type octavia_mgt_network_interface_match = {
    'Name' : string = 'o-hm0'
};

type octavia_mgt_network_interface_network = {
    'DHCP' : boolean = true
};

type octavia_mgt_network_interface_config = {
    'Match' : octavia_mgt_network_interface_match = dict()
    'Network' : octavia_mgt_network_interface_network = dict()
};


#########################################
# Octavia management network parameters #
#########################################

type octavia_mgt_network_config = {
    'mgt_port_ip_address' : type_ipv4 = '172.16.0.2'
    'internal_host' : type_hostname
    'octavia_hostname' : type_hostname
    'protocol' : choice('http', 'https') = 'http'
    'public_host' : type_hostname
    'region_name' : string
    'subnet' : type_ipv4_netmask_pair = '172.16.0.0/12'
    'subnet_start' : type_ipv4 = '172.16.0.100'
    'subnet_end' : type_ipv4 = '172.16.31.254'
};


############################################################
# Octavia DHCP client configuration for management network #
############################################################

type octavia_mgt_network_dhcp_client_options = {
    'request' : choice('subnet-mask', 'broadcast-address', 'interface-mtu')[] = list('subnet-mask', 'broadcast-address', 'interface-mtu')
    'do-forward-updates' : boolean = false
};

# Put the config in a config dict to simplify processing in TT file
type octavia_mgt_network_dhcp_client_config = {
    'config' : octavia_mgt_network_dhcp_client_options = dict()
};


############################################
# Octavia CA creation script configuration #
############################################

type octavia_ca_parameters_config = {
    'ca_cert_dir' : absolute_file_path = '/etc/octavia/certs'
    'priv_key_encryption_algorithm' : choice('aes-128-cbc', 'aes-256-cbc') = 'aes-256-cbc'
    'priv_key_length' : long =4096 with (SELF == 2048) || (SELF == 4096)
};
