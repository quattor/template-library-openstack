unique template features/mariadb/openstack/rpms/config;

'/software/packages' = {
    pkg_repl('mariadb');
    pkg_repl('mariadb-server');

    SELF;
};
