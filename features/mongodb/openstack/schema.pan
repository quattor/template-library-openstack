declaration template features/mongodb/openstack/schema;

type openstack_mongodb_config = {
    'bind_ip' : type_ipv4[] = list('127.0.0.1')
    'dbpath' ? absolute_file_path
    'fork' : boolean = true
    'journal' : boolean = true
};
