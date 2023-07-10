# Types related to Neutron ML2 plugin

declaration template types/openstack/neutron_ml2;

@documentation {
    Main configuration parameters for Neutron ML2 plugin
}
type openstack_neutron_ml2_core_config = {
    'extension_drivers' : string[]
    'mechanism_drivers' : string[]
    'tenant_network_types' : string[]
    'type_drivers' : string[]
};

@documentation {
    ml2_type_flat configuration parameters for Neutron ML2 plugin
}
type openstack_neutron_ml2_flat_config = {
    'flat_networks' : string[]
};

@documentation {
    ml2_type_vlan configuration parameters for Neutron ML2 plugin
}
type openstack_neutron_ml2_vlan_config = {
    'network_vlan_ranges' : string[]
};

@documentation {
    ml2_type_vxlan configuration parameters for Neutron ML2 plugin
}
type openstack_neutron_ml2_vxlan_config = {
    'vni_ranges' : string[]
};

@documentation {
    securitygroup configuration parameters for Neutron ML2 plugin
}
type openstack_neutron_ml2_securitygroup_config = {
    'firewall_driver' ? string
    'enable_ipset' ? boolean
    'enable_security_group' ? boolean
};

@documentation {
    List of configuration sections for Neutron ML2 plugin
}
type openstack_neutron_ml2_config = {
    'ml2' : openstack_neutron_ml2_core_config
    'ml2_type_flat' ? openstack_neutron_ml2_flat_config
    'ml2_type_vlan' ? openstack_neutron_ml2_vlan_config
    'ml2_type_vxlan' ? openstack_neutron_ml2_vxlan_config
    'securitygroup' ? openstack_neutron_ml2_securitygroup_config
};
