unique template personality/neutron/config;

# Include general openstack variables
include 'defaults/openstack/config';

variable OS_NODE_TYPE ?= error('OS_NODE_TYPE must be defined');

variable OS_NEUTRON_VLAN_RANGES ?= error('OS_NEUTRON_VLAN_RANGES undefined: must specify the network to use');

final variable OS_NEUTRON_BASE_TYPE = if ( (OS_NODE_TYPE == 'combined') || (OS_NODE_TYPE == 'controller') ) {
    'controller';
} else if ( (OS_NODE_TYPE == 'network') || (OS_NODE_TYPE == 'compute') ) {
    OS_NODE_TYPE;
} else {
    error('Invalid OS_NODE_TYPE value (%s)', OS_NODE_TYPE);
};

include 'features/neutron/' + OS_NEUTRON_BASE_TYPE + '/config';

include if ( (OS_NODE_TYPE == 'combined') || (OS_NODE_TYPE == 'network') ) 'features/neutron/network/config';

include if ( OS_NODE_TYPE != 'compute' ) 'features/memcache/config';
