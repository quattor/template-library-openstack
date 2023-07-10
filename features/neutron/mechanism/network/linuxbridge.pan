# linuxbridge mechanism specific to Neutron server
template features/neutron/mechanism/network/linuxbridge;

include 'features/neutron/agents/dhcp_agent';

include 'features/neutron/agents/metadata_agent';

include if ( OS_NEUTRON_VXLAN_ENABLED ) 'features/neutron/agents/l3_agent';
