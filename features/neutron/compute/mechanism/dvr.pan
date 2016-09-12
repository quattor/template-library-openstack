template features/neutron/compute/mechanism/dvr;

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
'contents/DEFAULT/agent_mode' = 'dvr';
'contents/DEFAULT/interface_driver' = OS_NEUTRON_INTERFACE_DRIVER;
'contents/DEFAULT/external_network_bridge' = '';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);


include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-l3-agent/on' = '';
'neutron-l3-agent/startstop' = true;
'neutron-metadata-agent/on' = '';
'neutron-metadata-agent/startstop' = true;
