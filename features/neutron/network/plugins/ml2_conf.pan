unique template features/neutron/network/plugins/ml2_conf;

# /etc/neutron/plugins/ml2/ml2_conf.ini
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/ml2_conf.ini}';
'module' = 'tiny';

prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/ml2_conf.ini}/contents';
# [ml2] section
'ml2/type_drivers' = OPENSTACK_NEUTRON_DRIVERS;
'ml2/mechanism_drivers' = openstack_list_to_string(OPENSTACK_NEUTRON_MECHANISM_DRIVERS);
'ml2/tenant_network_types' = OPENSTACK_NEUTRON_TENANT;
'ml2/extension_drivers' = 'port_security';

# [ml2_type_flat]
'ml2_type_flat/flat_networks' = 'public';

# [ml2_type_vxlan]
'ml2_type_vxlan' = { if (OPENSTACK_NEUTRON_VXLAN_ENABLED == 'True') {
        SELF['vni_ranges'] = OPENSTACK_NEUTRON_VXLAN_VNI_RANGES;
        SELF;
    } else {
        null;
    };
};

# [securitygroup]
'securitygroup/enable_ipset' = 'True';
