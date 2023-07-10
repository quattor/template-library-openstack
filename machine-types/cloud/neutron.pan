unique template machine-types/cloud/neutron;

# OS_NODE_TYPE must be one of controller (only), network or combined
variable OS_NODE_TYPE ?= 'combined';

include 'machine-types/cloud/base';

include 'personality/neutron/config';
