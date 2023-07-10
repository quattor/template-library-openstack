# RPMs added to all OpenStack nodes
template features/openstack/rpms;

'/software/packages' = {
    pkg_repl('openstack-selinux');
    pkg_repl('openstack-packstack');
    pkg_repl('python3-openstackclient');

    SELF;
};
