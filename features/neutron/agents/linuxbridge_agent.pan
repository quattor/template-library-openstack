unique template features/neutron/agents/linuxbridge_agent;

include 'types/openstack/neutron_agents';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'neutron-linuxbridge-agent/startstop' = true;

include 'components/metaconfig/config';

# Configure Netfilter for linuxbridge-agent
# Do not take any special action in case of changes as they are not expected to happen
# and taking a change into account basically requires a reboot
include 'features/neutron/agents/linuxbridge_agent/sysctl_schema';
prefix '/software/components/metaconfig/services/{/etc/sysctl.d/99-neutron-linuxbridge-agent.conf}';
'module' = 'tiny';
bind '/software/components/metaconfig/services/{/etc/sysctl.d/99-neutron-linuxbridge-agent.conf}/contents' = openstack_linuxbridge_agent_sysctl;
# Use default values from schema
'contents' = dict();

# /etc/neutron/plugins/ml2/linuxbridge_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/linuxbridge_agent.ini}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/neutron-linuxbridge-agent' = 'restart';
bind '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/linuxbridge_agent.ini}/contents' = openstack_neutron_lb_config;

# [linux_bridge] section
'contents/linux_bridge/physical_interface_mappings' = 'public:' + OS_INTERFACE_MAPPING;

# [vxlan] section
'contents/vxlan/enable_vxlan' = OS_NEUTRON_VXLAN_ENABLED;
'contents/vxlan' = if ( OS_NEUTRON_VXLAN_ENABLED ) {
    SELF['arp_responder'] = false;
    SELF['local_ip'] = OS_NEUTRON_OVERLAY_IP;
    SELF['l2_population'] = false;
    SELF;
} else {
    SELF;
};

# [agent] section
'contents/agent/prevent_arp_spoofing' = true;

# [securitygroup] section
'contents/securitygroup/enable_security_group' = true;
'contents/securitygroup/firewall_driver' = 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver';
