template personality/neutron/plugins/openvswitch/config;

# Include Open vSwitch plugin RPMs
include { 'personality/neutron/plugins/openvswitch/rpms' };

variable TENANT_NETWORK_TYPE ?= 'vlan';
variable BRIDGE_MAPPINGS ?= 'physnet1:br-eth1';
variable NETWORK_VLAN_RANGES ?= 'physnet1:1:4094';

#----------------------------------------------------------------------------- 
# Enable and start Open vSwitch service
#----------------------------------------------------------------------------- 

include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/openvswitch/on" = ""; 
"/software/components/chkconfig/service/openvswitch/startstop" = true;
"/software/components/chkconfig/service/neutron-ovs-cleanup/on" = "";

# create link
variable OPENVSWITCH_PLUGIN_CONFIG ?= '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini';
variable OPENVSWITCH_PLUGIN_CONFIG_CONTENTS ?= file_contents('personality/neutron/plugins/openvswitch/ovs_neutron_plugin.templ');
variable OPENVSWITCH_PLUGIN_CONFIG_CONTENTS=replace('TENANT_NETWORK_TYPE',TENANT_NETWORK_TYPE,OPENVSWITCH_PLUGIN_CONFIG_CONTENTS);
variable OPENVSWITCH_PLUGIN_CONFIG_CONTENTS=replace('BRIDGE_MAPPINGS',BRIDGE_MAPPINGS,OPENVSWITCH_PLUGIN_CONFIG_CONTENTS);
variable OPENVSWITCH_PLUGIN_CONFIG_CONTENTS=replace('NETWORK_VLAN_RANGES',NETWORK_VLAN_RANGES,OPENVSWITCH_PLUGIN_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(OPENVSWITCH_PLUGIN_CONFIG), nlist(
        "config",OPENVSWITCH_PLUGIN_CONFIG_CONTENTS,
        "owner","root:neutron",
        "perms","0640",
        "restart", "/sbin/service neutron-openvswitch-agent restart",

    ),
);

include { 'components/symlink/config' };
'/software/components/symlink/links'=push(
  nlist('name', '/etc/neutron/plugin.ini',
        'replace', nlist('all','yes','link','yes'),
        'target', '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
  ),
);
