unique template personality/keepalived/config;

# Floating IPs
variable FLOATING_IPS ?= list(
    dict("name", "Openstack",
        "master", OPENSTACK_LOADBALANCER_MASTER,
        "router_id", OPENSTACK_KEEPALIVED_ROUTER_ID,
        "ip", OPENSTACK_FLOATING_IP),
);


include 'features/keepalived/config';
