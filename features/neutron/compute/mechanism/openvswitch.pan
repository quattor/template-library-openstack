template features/neutron/compute/mechanism/openvswitch;

include 'features/neutron/compute/rpms/openvswitch';

# Restart neutron specific daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-openvswitch-agent/on' = '';
'neutron-openvswitch-agent/startstop' = true;

include 'features/neutron/compute/agents/openvswitch_agent';
