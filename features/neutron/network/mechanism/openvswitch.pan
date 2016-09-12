template features/neutron/network/mechanism/openvswitch;

include 'features/neutron/network/rpms/openvswitch';

include 'features/neutron/network/plugins/ml2_conf';

include 'features/neutron/network/agents/openvswitch_agent';

include 'features/neutron/network/agents/dhcp_agent';

include {
  if (OS_NEUTRON_VXLAN_ENABLED == 'True') {
    'features/neutron/network/agents/l3_agent';
  } else {
    null;
  };
};
