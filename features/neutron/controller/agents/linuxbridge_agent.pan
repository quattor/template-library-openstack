unique template features/neutron/controller/agents/linuxbridge_agent;

include 'components/metaconfig/config';

# /etc/neutron/plugins/ml2/linuxbridge_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/linuxbridge_agent.ini}';
'module' = 'tiny';

# [linux_bridge] section
'contents/linux_bridge/physical_interface_mappings' = 'public:' + OPENSTACK_INTERFACE_MAPPING;

# [vxlan] section
'contents/vxlan/enable_vxlan' = OPENSTACK_NEUTRON_VXLAN_ENABLED;
'contents/vxlan' = { if (OPENSTACK_NEUTRON_VXLAN_ENABLED == 'True') {
    SELF['local_ip'] = OPENSTACK_NEUTRON_OVERLAY_IP;
    SELF['l2_population'] = 'True';
    SELF;
  } else {
    SELF;
  };
};

# [agent] section
'contents/agent/prevent_arp_spoofing' = 'True';

# [securitygroup] section
'contents/securitygroup/enable_security_group' = 'True';
'contents/securitygroup/firewall_driver' = 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver';
