unique template features/neutron/plugins/ml2_conf;

variable OS_NEUTRON_VLAN_RANGES ?= error('OS_NEUTRON_VLAN_RANGES undefined: must specify the network to use');

include 'types/openstack/neutron_ml2';

'/software/packages' = pkg_repl('openstack-neutron-ml2');

# /etc/neutron/plugins/ml2/ml2_conf.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/ml2_conf.ini}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
bind '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/ml2_conf.ini}/contents' = openstack_neutron_ml2_config;

# [ml2] section
'contents/ml2/type_drivers' = OS_NEUTRON_DRIVERS;
'contents/ml2/mechanism_drivers' = OS_NEUTRON_MECHANISM_DRIVERS;
'contents/ml2/tenant_network_types' = OS_NEUTRON_TENANT_NETWORK_TYPES;
'contents/ml2/extension_drivers' = list('port_security');

# [ml2_type_flat]
'contents/ml2_type_flat/flat_networks' = list('public');

# [ml2_type_vlan]
'contents/ml2_type_vlan/network_vlan_ranges' = OS_NEUTRON_VLAN_RANGES;

# [ml2_type_vxlan]
'contents/ml2_type_vxlan' = if ( OS_NEUTRON_VXLAN_ENABLED ) {
    SELF['vni_ranges'] = OS_NEUTRON_VXLAN_VNI_RANGES;
    SELF;
} else {
    null;
};

# [securitygroup]
'contents/securitygroup/enable_ipset' = true;
