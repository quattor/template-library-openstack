unique template features/octavia/rpms;

'/software/packages' = {
    pkg_repl('dhcp-client');
    pkg_repl('openstack-octavia-api');
    pkg_repl('openstack-octavia-diskimage-create');
    pkg_repl('openstack-octavia-health-manager');
    pkg_repl('openstack-octavia-housekeeping');
    pkg_repl('openstack-octavia-worker');
    pkg_repl('python3-octavia');
    pkg_repl('python3-octaviaclient');

    SELF;
};
