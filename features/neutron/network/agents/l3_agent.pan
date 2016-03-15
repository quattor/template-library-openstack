unique template features/neutron/network/agents/l3_agent;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-l3-agent/on' = '';
'neutron-l3-agent/startstop' = true;

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/neutron/l3_agent.ini}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT/interface_driver' = 'neutron.agent.linux.interface.BridgeInterfaceDriver';
'contents/DEFAULT/external_network_bridge' = '';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);