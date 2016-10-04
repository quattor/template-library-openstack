unique template features/neutron/variables/linuxbridge/provider-service;

variable OS_NEUTRON_MECHANISM ?= 'linuxbridge';
variable OS_NEUTRON_VXLAN_ENABLED ?= 'False';
variable OS_NEUTRON_DRIVERS ?= 'flat,vlan';

variable OS_NEUTRON_TENANT ?= '';
variable OS_NEUTRON_MECHANISM_DRIVERS ?= list(OS_NEUTRON_MECHANISM);
variable OS_NEUTRON_INTERFACE_DRIVER ?= 'neutron.agent.linux.interface.BridgeInterfaceDriver';
variable OS_NEUTRON_VXLAN_VNI_RANGES ?= null;
