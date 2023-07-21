unique template features/mariadb/openstack/schema;

type openstack_mariadb_mysqld_config = {
    'max_connections' : long(10..100000) = 50000
    'max_connect_errors' : long(1..4294967295) = 1000
    'symbolic-links' : long(0..1) = 0
};

type openstack_mariadb_config = {
    'mysqld' ? openstack_mariadb_mysqld_config
};
