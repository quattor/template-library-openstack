unique template personality/neutron/config;

include 'features/neutron/' + OPENSTACK_NODE_TYPE + '/config';

include { if (((OPENSTACK_NEUTRON_NETWORK_PROVIDER == openstack_get_controller_host(OPENSTACK_NEUTRON_SERVERS))) &&
  (OPENSTACK_NEUTRON_NETWORK_PROVIDER == FULL_HOSTNAME) ){
  'features/neutron/network/config';
} else {
  null;
};

};
