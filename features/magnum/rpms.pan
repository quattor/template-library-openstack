unique template features/magnum/rpms;

'/software/packages'  = {
    pkg_repl('apr-util');
    pkg_repl('apr');
    pkg_repl('python3-magnumclient');
    pkg_repl('openstack-magnum-api');
    pkg_repl('openstack-magnum-conductor');
    pkg_repl('libibverbs');

    SELF;
};
