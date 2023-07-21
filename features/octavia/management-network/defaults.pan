# This template defines some default values that must be available both
# when Octavia is located on the Neutron server or when Octavia is on a
# separate machine.

unique template features/octavia/management-network/defaults;

variable OS_OCTAVIA_MGMT_NETWORK_MGT_PORT_IP ?= '172.16.0.2';
variable OS_OCTAVIA_MGMT_NETWORK_SUBNET ?= '172.16.0.0/12';
variable OS_OCTAVIA_MGMT_NETWORK_SUBNET_START ?= '172.16.0.100';
variable OS_OCTAVIA_MGMT_NETWORK_SUBNET_END ?= '172.16.31.254';

