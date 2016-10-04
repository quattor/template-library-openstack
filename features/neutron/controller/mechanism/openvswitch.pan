template features/neutron/controller/mechanism/openvswitch;

include 'features/neutron/controller/rpms/openvswitch';

include 'features/neutron/controller/plugins/ml2_conf';

include 'features/neutron/controller/agents/openvswitch_agent';

include {
  if (exists(OPENSTACK_NEUTRON_DVR_ENABLED) && OPENSTACK_NEUTRON_DVR_ENABLED) {
    'features/neutron/controller/mechanism/dvr';
  } else {
    null;
  };
};

include {
  if (exists(OPENSTACK_NEUTRON_DVR_ENABLED) && OPENSTACK_NEUTRON_DVR_ENABLED) {
    'features/neutron/variables/openvswitch/dvr';
  } else {
    null;
  };
};
