unique template personality/keepalived/config;

# Floating IPs
variable FLOATING_IPS ?= list(
    dict("name", "Openstack",
        "master", OS_LOADBALANCER_MASTER,
        "router_id", OS_KEEPALIVED_ROUTER_ID,
        "ip", OS_FLOATING_IP),
);


include 'features/keepalived/config';
