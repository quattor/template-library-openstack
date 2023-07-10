unique template features/neutron/agents/lbaas;

include 'types/openstack/neutron_agents';

# Install openstack-neutron-lbaas package
'/software/packages' = pkg_repl('openstack-neutron-lbaas');

# Modify /etc/neutron/neutron.conf to add lbaasv2 plugin
 prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents/';
'DEFAULT/service_plugins' = list('router', 'neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2');
'service_providers/service_provider' = 'LOADBALANCERV2:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default';

# Modify /etc/neutron/lbaas_agent.ini to configure interface_driver
prefix '/software/components/metaconfig/services/{/etc/neutron/lbaas_agent.ini}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
bind '/software/components/metaconfig/services/{/etc/neutron/lbaas_agent.ini}/contents' = openstack_neutron_lbaas_config;

# DEFAULT section
'contents/DEFAULT/interface_driver' = 'neutron.agent.linux.interface.BridgeInterfaceDriver';

# Make sure neutron-lbaasv2-agent is started
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'neutron-lbaasv2-agent/startstop' = true;

