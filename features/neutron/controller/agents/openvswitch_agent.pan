unique template features/neutron/controller/agents/openvswitch_agent;

include 'components/metaconfig/config';

# /etc/neutron/plugins/ml2/openvswitch_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/openvswitch_agent.ini}';
'module' = 'tiny';

# [ovs] section
'contents/ovs/local_ip' = OPENSTACK_NEUTRON_OVERLAY_IP;
'contents/ovs/bridge_mappings' = 'public:' + OPENSTACK_INTERFACE_MAPPING;

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
