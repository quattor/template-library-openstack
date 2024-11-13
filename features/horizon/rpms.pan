unique template features/horizon/rpms;

'/software/packages' = {
    pkg_repl('openstack-dashboard');

    if ( is_defined(OS_MAGNUM_CONTROLLER_HOST) ) {
        pkg_repl('openstack-magnum-ui');
        pkg_repl('openstack-heat-ui');
    };

    if ( is_defined(OS_MAGNUM_CONTROLLER_HOST) ) {
        pkg_repl('openstack-octavia-ui');
    };

    SELF;
};
