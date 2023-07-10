unique template features/placement/rpms;

'/software/packages' = {
    pkg_repl('openstack-placement-api');
    pkg_repl('python3-osc-placement');
    openstack_add_httpd_packages( OS_PLACEMENT_CONTROLLER_PROTOCOL == 'https' );

    SELF;
};
