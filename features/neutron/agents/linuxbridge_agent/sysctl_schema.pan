declaration template features/neutron/agents/linuxbridge_agent/sysctl_schema;

type openstack_linuxbridge_agent_sysctl = {
    "net.bridge.bridge-nf-call-arptables" : long(0..1) = 1
    "net.bridge.bridge-nf-call-iptables" : long(0..1) = 1
    "net.bridge.bridge-nf-call-ip6tables" : long(0..1) = 1
    "net.ipv4.conf.default.rp_filter" : long(0..2) = 0
    "net.ipv4.conf.all.rp_filter" : long(0..2) = 0
};
