unique template features/keepalived/config;

include 'features/keepalived/rpms/config';

# Need the ability to bind to IP addresses which are not assigned to a device
# on the local system
include 'components/sysctl/config';
"/software/components/sysctl/variables/net.ipv4.ip_nonlocal_bind" = "1";

# Configuration
variable KEEPALIVED_INIT ?= <<EOF;
global_defs {
    router_id %s
}
vrrp_script haproxy {
    script "killall -0 haproxy"
    interval 2
    weight 2
}
EOF

variable VRRP_INSTANCE ?= <<EOF;
vrrp_instance %s {
    virtual_router_id %d
    advert_int 1
    priority %d
    state %s
    interface eth0
    virtual_ipaddress {
        %s dev eth0
    }
    track_script {
        haproxy
    }
}
EOF

variable FLOATING_IPS ?= error("FLOATING_IPS must be defined");

variable KEEPALIVED_CONFIG = {
    cfg = format(KEEPALIVED_INIT, value("/system/network/hostname"));
    foreach (i; fip; FLOATING_IPS) {
        if (FULL_HOSTNAME == fip["master"]) {
            cfg = cfg + format(VRRP_INSTANCE, fip["name"], fip["router_id"], 101, "MASTER", fip["ip"]);
        } else {
            cfg = cfg + format(VRRP_INSTANCE, fip["name"], fip["router_id"], 100, "BACKUP", fip["ip"]);
        };
    };
    cfg;
};

include 'components/filecopy/config';
'/software/components/filecopy/services/{/etc/keepalived/keepalived.conf}' = dict(
    'config', KEEPALIVED_CONFIG,
    'backup', false,
    'owner', 'root:root',
    'restart', 'service keepalived reload',
    'perms', '0644',
);

# Services
include 'components/chkconfig/config';
prefix "/software/components/chkconfig/service";

"keepalived/on" = "";
"keepalived/startstop" = true;
