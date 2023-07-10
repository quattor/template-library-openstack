unique template features/neutron/agents/l3_agent;

include 'types/openstack/neutron_agents';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'neutron-l3-agent/startstop' = true;

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/neutron/l3_agent.ini}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
bind '/software/components/metaconfig/services/{/etc/neutron/l3_agent.ini}/contents' = openstack_neutron_l3_agent_config;

# [DEFAULT]
'contents/DEFAULT/interface_driver' = 'neutron.agent.linux.interface.BridgeInterfaceDriver';
'contents/DEFAULT/external_network_bridge' = '';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
