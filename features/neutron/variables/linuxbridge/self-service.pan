unique template features/neutron/variables/linuxbridge/self-service;

variable OPENSTACK_NEUTRON_MECHANISM ?= 'linuxbridge';
variable OPENSTACK_NEUTRON_MECHANISM_DRIVERS ?= list('linuxbridge','l2population');

variable OPENSTACK_NEUTRON_VXLAN_ENABLED ?= 'True';
variable OPENSTACK_NEUTRON_DRIVERS ?= 'vlan,flat,vxlan';

variable OPENSTACK_NEUTRON_TENANT ?= 'vxlan';
variable OPENSTACK_NEUTRON_VXLAN_VNI_RANGES ?= '1:1000';
variable OPENSTACK_NEUTRON_INTERFACE_DRIVER ?= 'neutron.agent.linux.interface.BridgeInterfaceDriver';

variable OPENSTACK_NEUTRON_DNSMASQ_CONFIG_PARAMS ?= '26,1450';
