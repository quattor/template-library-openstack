unique template features/mariadb/functions;

@{generate mysql/masiadb users config based on servers, username and password}
function mariadb_openstack_addusers = {
    servers = ARGV[0];
    username = ARGV[1];
    passwd = ARGV[2];

    value = dict(
        'password', password,
        'rights', list('ALL PRIVILEGES'),
    );

    if (OPENSTACK_HA) {
        users = dict();
        foreach(k; v; servers) {
            users[escape(username + "@" + k)] = value;
        };
        users;
    } else {
        dict(username, value);
    };
};
