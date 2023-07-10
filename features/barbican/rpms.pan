unique template features/barbican/rpms;

include 'defaults/openstack/functions';

'/software/packages'  = {
    pkg_repl('python3-barbicanclient');
    pkg_repl('python3-barbican');
    pkg_repl('openstack-barbican-api');
    pkg_repl('libibverbs');
    openstack_add_httpd_packages( OS_BARBICAN_PROTOCOL == 'https' );

    SELF;
};
