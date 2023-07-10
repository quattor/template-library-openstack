unique template features/neutron/variables/self-service;

variable OS_NEUTRON_MECHANISM ?= 'linuxbridge';
variable OS_NEUTRON_MECHANISM_DRIVERS ?= list('linuxbridge','l2population');

variable OS_NEUTRON_VXLAN_ENABLED ?= true;
variable OS_NEUTRON_DRIVERS ?= list('vlan','flat','vxlan');

variable OS_NEUTRON_TENANT_NETWORK_TYPES ?= list('vxlan');
variable OS_NEUTRON_VXLAN_VNI_RANGES ?= list('1:1000');

variable OS_NEUTRON_DNSMASQ_CONFIG_PARAMS ?= '26,1450';
