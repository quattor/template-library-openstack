template features/neutron/compute/mechanism/linuxbridge;

include 'features/neutron/compute/rpms/linuxbridge';

# Restart neutron specific daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-linuxbridge-agent/on' = '';
'neutron-linuxbridge-agent/startstop' = true;

include 'features/neutron/compute/agents/linuxbridge_agent';