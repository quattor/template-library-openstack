template personality/neutron/plugins/ml2/config;

# This ML2 implementation use Open VSwitch to configure the network
# Include ML2 plugin RPMs
include { 'personality/neutron/plugins/ml2/rpms' };

variable NETWORK_VLAN_RANGES ?= 'physnet1:1:4094';

variable ML2_PLUGIN_CONFIG ?= '/etc/neutron/plugins/ml2/ml2_conf.ini';
variable ML2_PLUGIN_CONFIG_CONTENTS ?= file_contents('personality/neutron/plugins/ml2/ml2_conf.templ');
variable ML2_PLUGIN_CONFIG_CONTENTS=replace('NETWORK_VLAN_RANGES',NETWORK_VLAN_RANGES,ML2_PLUGIN_CONFIG_CONTENTS);

variable OPENVSWITCH_INCLUDE ?= {
  if (NEUTRON_NODE_TYPE == 'controller') {
    null;
  } else {
    'personality/neutron/plugins/openvswitch/config';
  };
};

include { OPENVSWITCH_INCLUDE };

"/software/components/filecopy/services" = npush(
    escape(ML2_PLUGIN_CONFIG), nlist(
        "config",ML2_PLUGIN_CONFIG_CONTENTS,
        "owner","root:neutron",
        "perms","0640",
        "restart", "/sbin/service neutron-openvswitch-agent restart",

    ),
);
