unique template features/heat/rpms;

'/software/packages'  = {
    pkg_repl('apr-util');
    pkg_repl('apr');
    pkg_repl('python3-heatclient');
    pkg_repl('openstack-heat-api');
    pkg_repl('openstack-heat-api-cfn');
    pkg_repl('openstack-heat-engine');
    pkg_repl('libibverbs');

    SELF;
};
