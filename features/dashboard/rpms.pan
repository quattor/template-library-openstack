unique template features/dashboard/rpms;

'/software/packages' = {
    pkg_repl('openstack-dashboard');

    if ( is_defined(OS_MAGNUM_HOST) ) {
       pkg_repl('openstack-magnum-ui');
       pkg_repl('openstack-heat-ui');
    };

    if ( is_defined(OS_MAGNUM_HOST) ) {
       pkg_repl('openstack-octavia-ui');
    };

    openstack_add_httpd_packages( OS_HORIZON_PROTOCOL == 'https' );

    SELF;
};
