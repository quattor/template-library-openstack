unique template features/neutron/network/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OS_NEUTRON_NETWORK_TYPE;

# Include common server configuration
include 'features/neutron/server';

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
# As the network server component can be on the same machine as the Neutron server, we need to allow
# all sections/attributes supported on a Neutron server
bind '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents' = openstack_neutron_server_config;

# [DEFAULT]
'contents/DEFAULT/base_mac' = OS_NEUTRON_BASE_MAC;
'contents/DEFAULT/dvr_base_mac' = OS_NEUTRON_DVR_BASE_MAC;

