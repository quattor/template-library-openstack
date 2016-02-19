unique template personality/neutron/config;

include 'features/neutron/' + OS_NODE_TYPE + '/config';

include { if ((OS_NEUTRON_NETWORK_PROVIDER == OS_NEUTRON_CONTROLLER_HOST) &&
  (OS_NEUTRON_NETWORK_PROVIDER == FULL_HOSTNAME) ){
  'features/neutron/network/config';
} else {
  null;
};

};
