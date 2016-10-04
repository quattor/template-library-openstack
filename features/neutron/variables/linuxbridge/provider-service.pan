unique template features/neutron/variables/linuxbridge/provider-service;

variable OPENSTACK_NEUTRON_MECHANISM ?= 'linuxbridge';
variable OPENSTACK_NEUTRON_VXLAN_ENABLED ?= 'False';
variable OPENSTACK_NEUTRON_DRIVERS ?= 'flat,vlan';

variable OPENSTACK_NEUTRON_TENANT ?= '';
variable OPENSTACK_NEUTRON_MECHANISM_DRIVERS ?= list(OPENSTACK_NEUTRON_MECHANISM);
variable OPENSTACK_NEUTRON_INTERFACE_DRIVER ?= 'neutron.agent.linux.interface.BridgeInterfaceDriver';
variable OPENSTACK_NEUTRON_VXLAN_VNI_RANGES ?= null;
