unique template personality/neutron/config;

include 'features/neutron/' + OPENSTACK_NODE_TYPE + '/config';

include { if ((OPENSTACK_NEUTRON_NETWORK_PROVIDER == OPENSTACK_NEUTRON_CONTROLLER_HOST) &&
  (OPENSTACK_NEUTRON_NETWORK_PROVIDER == FULL_HOSTNAME) ){
  'features/neutron/network/config';
} else {
  null;
};

};
