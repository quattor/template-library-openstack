unique template features/neutron/controller/plugins/ml2_conf;

include 'components/metaconfig/config';

# /etc/neutron/plugins/ml2/ml2_conf.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/ml2_conf.ini}';
'module' = 'tiny';
# [ml2] section
'contents/ml2/type_drivers' = OS_NEUTRON_DRIVERS;
'contents/ml2/mechanism_drivers' = OS_NEUTRON_MECHANISM;
'contents/ml2/tenant_network_types' = OS_NEUTRON_TENANT;
'contents/ml2/extension_drivers' = 'port_security';

# [ml2_type_flat]
'contents/ml2_type_flat/flat_networks' = 'public';

# [ml2_type_vxlan]
'contents/ml2_type_vxlan' = { if (OS_NEUTRON_VXLAN_ENABLED == 'True') {
    SELF['vni_ranges'] = OS_NEUTRON_VXLAN_VNI_RANGES;
    SELF;
  } else {
    null;
  };
};

# [securitygroup]
'contents/securitygroup/enable_ipset' = 'True';
