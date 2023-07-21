unique template features/glance/rpms;

'/software/packages'  = {
    pkg_repl('python3-boto3');
    pkg_repl('python3-glanceclient');
    pkg_repl('python3-glance');
    pkg_repl('openstack-glance');

    SELF;
};
