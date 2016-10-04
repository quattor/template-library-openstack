unique template features/neutron/compute/agents/openvswitch_agent;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openvswitch/on' = '';
'openvswitch/startstop' = true;
'neutron-openvswitch-agent/on' = '';
'neutron-openvswitch-agent/startstop' = true;

include 'components/metaconfig/config';

# Configuration file for openvswitch_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/openvswitch_agent.ini}';
'module' = 'tiny';

# [agent] section
'contents/agent/prevent_arp_spoofing' = 'True';
'contents/agent/tunnel_types' = 'vxlan';
'contents/agent/l2_population' = 'True';

# [ovs] section
'contents/ovs/bridge_mappings' = 'public:' + OPENSTACK_INTERFACE_MAPPING;
'contents/ovs/local_ip' = OPENSTACK_NEUTRON_OVERLAY_IP;;

# [securitygroup] section
'contents/securitygroup/enable_security_group' = 'True';
'contents/securitygroup/firewall_driver' = 'iptables_hybrid';
