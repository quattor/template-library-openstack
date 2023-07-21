unique template features/nova/controller/rpms;

include 'defaults/openstack/functions';

'/software/packages' = {
    pkg_repl('openstack-nova-api');
    pkg_repl('openstack-nova-conductor');
    pkg_repl('openstack-nova-novncproxy');
    pkg_repl('openstack-nova-scheduler');
    pkg_repl('python3-etcd3gw');
    pkg_repl('python3-novaclient');
    openstack_add_httpd_packages( OS_NOVA_CONTROLLER_PROTOCOL == 'https' );

    SELF;
};
