template features/neutron/network/mechanism/linuxbridge;

include 'features/neutron/network/rpms/linuxbridge';

include 'features/neutron/network/plugins/ml2_conf';

include 'features/neutron/network/agents/linuxbridge_agent';

include 'features/neutron/network/agents/dhcp_agent';

include {
  if (OS_NEUTRON_VXLAN_ENABLED == 'True') {
    'features/neutron/network/agents/l3_agent';
  } else {
    null;
  };
};