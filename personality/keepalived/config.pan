unique template personality/keepalived/config;

# Floating IPs
variable FLOATING_IPS ?= list(
    dict("name", "Openstack",
        "master", OS_LOADBALANCER_MASTER,
        "router_id", 52,
        "ip", OS_FLOATING_IP),
);


include 'features/keepalived/config';
