unique template features/neutron/network/agents/linuxbridge_agent;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-linuxbridge-agent/on' = '';
'neutron-linuxbridge-agent/startstop' = true;

include 'components/metaconfig/config';

# /etc/neutron/plugins/ml2/linuxbridge_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/linuxbridge_agent.ini}';
'module' = 'tiny';

# [linux_bridge] section
'contents/linux_bridge/physical_interface_mappings' = 'public:' + OS_INTERFACE_MAPPING;

# [vxlan] section
'contents/vxlan/enable_vxlan' = OS_NEUTRON_VXLAN_ENABLED;
'contents/vxlan' = { if (OS_NEUTRON_VXLAN_ENABLED == 'True') {
    SELF['local_ip'] = OS_NEUTRON_OVERLAY_IP;
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
