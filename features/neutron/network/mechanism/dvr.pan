template features/neutron/network/mechanism/dvr;

include 'components/metaconfig/config';

# /etc/neutron/plugins/ml2/openvswitch_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/openvswitch_agent.ini}';
'module' = 'tiny';

# [agent] section
'contents/agent/prevent_arp_spoofing' = 'False';
'contents/agent/enable_distributed_routing' = 'True';
'contents/agent/arp_responder' = 'True';

prefix '/software/components/metaconfig/services/{/etc/neutron/l3_agent.ini}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT/agent_mode' = 'dvr_snat';
