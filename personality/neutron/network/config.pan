# Template configuring Neutron network node

unique template personality/neutron/network/config;

variable NEUTRON_SERVICES ?= list('neutron-openvswitch-agent','neutron-dhcp-agent','neutron-metadata-agent','neutron-l3-agent');
variable NEUTRON_NODE_TYPE ?= 'network';
variable METADATA_IP ?= DB_IP[escape(FULL_HOSTNAME)];

# include configuration common to client and server
include { 'personality/neutron/config' };


#----------------------------------------------------------------------------
# Define several sysctl variables for the networking
#----------------------------------------------------------------------------

include { 'components/sysctl/config' };

'/software/components/sysctl/variables/net.ipv4.ip_forward' = '1';
'/software/components/sysctl/variables/net.ipv4.conf.all.rp_filter' = '0';
'/software/components/sysctl/variables/net.ipv4.conf.default.rp_filter' = '0';


#----------------------------------------------------------------------------
# DHCP Agent configuration
#----------------------------------------------------------------------------

variable DHCP_AGENT_CONFIG ?= '/etc/neutron/dhcp_agent.ini';
variable DHCP_AGENT_CONFIG_CONTENTS ?= file_contents('personality/neutron/network/templates/dhcp_agent.templ');

"/software/components/filecopy/services" = npush(
    escape(DHCP_AGENT_CONFIG), nlist(
        "config",DHCP_AGENT_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service neutron-dhcp-agent restart",
    ),
);


#----------------------------------------------------------------------------
# L3 Agent configuration
#----------------------------------------------------------------------------

variable L3_AGENT_INI ?= '/etc/neutron/l3_agent.ini';
variable L3_AGENT_INI_CONTENTS ?= file_contents('personality/neutron/network/templates/l3_agent.templ');

variable L3_AGENT_INI_CONTENTS=replace('METADATA_IP',METADATA_IP,L3_AGENT_INI_CONTENTS);
variable L3_AGENT_INI_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_INTERNAL_ENDPOINT,L3_AGENT_INI_CONTENTS);
variable L3_AGENT_INI_CONTENTS=replace('NEUTRON_KEYSTONE_TENANT',NEUTRON_KEYSTONE_TENANT,L3_AGENT_INI_CONTENTS);
variable L3_AGENT_INI_CONTENTS=replace('NEUTRON_KEYSTONE_USER',NEUTRON_KEYSTONE_USER,L3_AGENT_INI_CONTENTS);
variable L3_AGENT_INI_CONTENTS=replace('NEUTRON_KEYSTONE_PASSWORD',NEUTRON_KEYSTONE_PASSWORD,L3_AGENT_INI_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(L3_AGENT_INI), nlist(
        "config",L3_AGENT_INI_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service neutron-l3-agent restart",
    ),
);
