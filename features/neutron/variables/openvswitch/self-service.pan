unique template features/neutron/variables/openvswitch/self-service;

variable OS_NEUTRON_MECHANISM ?= 'openvswitch';
variable OS_NEUTRON_MECHANISM_DRIVERS ?= list('openvswitch','l2population');

variable OS_NEUTRON_VXLAN_ENABLED ?= 'True';
variable OS_NEUTRON_DRIVERS ?= 'vlan,flat,vxlan';

variable OS_NEUTRON_TENANT ?= 'vxlan';
variable OS_NEUTRON_VXLAN_VNI_RANGES ?= '1:1000';
variable OS_NEUTRON_INTERFACE_DRIVER ?= 'neutron.agent.linux.interface.OVSInterfaceDriver';

variable OS_NEUTRON_DNSMASQ_CONFIG_PARAMS ?= '26,1450';
