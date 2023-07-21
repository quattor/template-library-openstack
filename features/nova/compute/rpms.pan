unique template features/nova/compute/rpms;

'/software/packages' = {
    pkg_repl('openstack-nova-compute');
    pkg_repl('sysfsutils');

    SELF;
};
