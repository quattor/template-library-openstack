unique template features/cinder/rpms;

'/software/packages' = {
    pkg_repl('openstack-cinder');
    pkg_repl('python3-cinderclient');

    SELF;
};
