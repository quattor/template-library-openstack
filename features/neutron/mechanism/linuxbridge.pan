template features/neutron/mechanism/linuxbridge;

'/software/packages' = pkg_repl('openstack-neutron-linuxbridge');

include 'features/neutron/agents/linuxbridge_agent';

include if ( (OS_NODE_TYPE == 'combined') || (OS_NODE_TYPE == 'network') ) 'features/neutron/mechanism/network/linuxbridge';
