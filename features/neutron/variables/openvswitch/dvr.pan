unique template features/neutron/variables/openvswitch/dvr;

variable OPENSTACK_NEUTRON_DVR_BASE_MAC ?= error('OPENSTACK_NEUTRON_DVR_BASE_MAC must be set when using Distributed Virtual Routing');
