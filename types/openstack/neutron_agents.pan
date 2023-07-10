# Type declarations for Neutron agents

declaration template types/openstack/neutron_agents;

include 'types/openstack/neutron_ml2';


###############
# linuxbridge #
###############

@documentation {
    linuxbridge agent configuration parameters
}
type openstack_neutron_lb_agent_config = {
    'prevent_arp_spoofing' ? boolean
};

@documentation {
    Main configuration parameters for linuxbridge agent
}
type openstack_neutron_lb_core_config = {
    'physical_interface_mappings' : string
};

@documentation {
    linuxbridge vxlan configuration parameters
}
type openstack_neutron_lb_vxlan_config = {
    'arp_responder' : boolean
    'enable_vxlan' : boolean
    'l2_population' : boolean
    'local_ip' : type_ipv4
};

@documentation {
    List of configuration sections for Neutron linuxbridge agent
}
type openstack_neutron_lb_config = {
    'agent' : openstack_neutron_lb_agent_config
    'linux_bridge' : openstack_neutron_lb_core_config
    'securitygroup' ? openstack_neutron_ml2_securitygroup_config
    'vxlan' : openstack_neutron_lb_vxlan_config
};


##############
# DHCP agent #
##############

@documentation {
    Main configuration parameters for DHCP agent
}
type openstack_neutron_dhcp_core_config = {
    include openstack_logging_config
    'dhcp_driver' : string
    'dhcp_lease_duration' : long
    'dnsmasq_config_file' : absolute_file_path
    'enable_isolated_metadata' : boolean
    'interface_driver' : string
};

@documentation {
    List of configuration sections for Neutron DHCP agent
}
type openstack_neutron_dhcp_config = {
    'DEFAULT' : openstack_neutron_dhcp_core_config
};


############
# L3 agent #
############

@documentation {
    Main configuration parameters for Neutron L3 agent
}
type openstack_neutron_l3_agent_core_config = {
    include openstack_logging_config
    'external_network_bridge' : string
    'interface_driver' : string
};

@documentation {
    List of configuration sections for Neutron L3 agent
}
type openstack_neutron_l3_agent_config = {
    'DEFAULT' : openstack_neutron_l3_agent_core_config
};


###############
# lbaas agent #
###############

@documentation {
    Main configuration parameters for Neutron lbaas agent
}
type openstack_neutron_lbaas_core_config = {
    'interface_driver' : string
};

@documentation {
    List of configuration sections for Neutron lbaas agent
}
type openstack_neutron_lbaas_config = {
    'DEFAULT' : openstack_neutron_lbaas_core_config
};


############
# metadata agent #
############

@documentation {
    Main configuration parameters for Neutron metadata agent
}
type openstack_neutron_metadata_core_config = {
    include openstack_keystone_authtoken
    include openstack_logging_config
    'auth_regions' : string
    'metadata_proxy_shared_secret' : string
    'nova_metadata_host' : type_fqdn
};

@documentation {
    List of configuration sections for Neutron metadata agent
}
type openstack_neutron_metadata_config = {
    'DEFAULT' : openstack_neutron_metadata_core_config
};

