unique template defaults/openstack/functions;

function openstack_load_config = {
    if (ARGC != 1 ) {
        error('openstack_load_config need a argument');
    };

    if (is_string(ARGV[0])) {
        config = create(ARGV[0]);
    } else if (!is_dict(ARGV[0])) {
        error('openstack_load_config need a string or a dict as argument');
    } else {
        config = ARGV[0];
    };

    foreach(k; v; config) {
        SELF[k] = v;
    };
    SELF;
};

# FIXME: As I use tiny metaconfig module, i can't just put list to have
# element1, element2, ...
function openstack_list_to_string = {
    if (ARGC != 1 ) {
        error('openstack_load_config need a argument');
    };

    if (is_list(ARGV[0])) {
        config = ARGV[0];
    } else    {
        error('openstack_list_to_string need a list as an argument');
    };

    result = '';

    foreach(k; v; config) {
        if (result != '') {
            result = format(
                '%s,%s',
                result,
                v
            );
        } else {
            result = v;
        };

        result;
    };
};

function openstack_dict_to_hostport_string = {
    if (ARGC != 1) {
        error('openstack_dict_to_hostport_string needs an argument');
    };

    if (is_dict(ARGV[0])) {
        config = ARGV[0];
    } else {
        error('openstack_dict_to_hostport_string needs a dict as an argument');
    };
    result = '';
    foreach(k; v; config) {
        if (result != '') {
            result = format(
                '%s,%s:%d',
                result,
                k,
                v
            );
        } else {
            result = format(
                '%s:%d',
                k,
                v
            );
        };

        result;
    };
};

function openstack_dict_to_connection_string = {
    if (ARGC != 1) {
        error('openstack_dict_to_connection_string needs an argument');
    };

    if (is_dict(ARGV[0])) {
        config = ARGV[0];
    } else {
        error('openstack_dict_to_connection_string needs a dict as an argument');
    };
    result = format(
        '%s://%s:%s@%s:%d/%s',
        config['dbprotocol'],
        config['dbuser'],
        config['dbpassword'],
        config['dbhost'],
        config['dbport'],
        config['dbname']
    );
    result;
};


function openstack_generate_uri = {
    if (ARGC != 3) {
        error('openstack_generate_uri needs an argument');
    };

    if (is_dict(ARGV[1])) {
        dict_of_hosts = ARGV[1];
    } else {
        error('openstack_generate_uri needs a dict as an argument');
    };
    protocol = ARGV[0];
    port = ARGV[2];


    if (length(dict_of_hosts) == 1) {
        result = foreach (k; v; dict_of_hosts[0]) {
            format(
                '%s://%s:%d',
                protocol,
                k,
                port
            );
        };
    } else {
        result = format(
            '%s://%s:%d',
            protocol,
            OPENSTACK_CONTROLLER_HOST,
            port
        );
    };
    result;
};

function openstack_get_controller_host = {
    if (ARGC != 1) {
        error('openstack_get_controller_host needs an argument');
    };

    if (is_dict(ARGV[0])) {
        dict_of_hosts = ARGV[0];
    } else {
        error('openstack_get_controller_host needs a list as an argument');
    };

    if (length(dict_of_hosts) == 1) {
        result = foreach (k; v; dict_of_hosts[0]) {
            k;
        };
    } else {
        result = OPENSTACK_CONTROLLER_HOST;
    };
    result;

};

function openstack_dict_to_transport_string = {
    if (ARGC != 1) {
        error('openstack_dict_to_transport_string needs an argument');
    };

    if (is_dict(ARGV[0])) {
        config = ARGV[0];
    } else {
        error('openstack_dict_to_transport_string needs a dict as an argument');
    };
    transport_url = format('%s://', config['rabbitprotocol']);
    foreach (k; v; config['rabbithosts']) {
        transport_url = transport_url + format(
            '%s:%s@%s:%d,',
            config['rabbituser'],
            config['rabbitpassword'],
            k,
            v,
        );
    };
    replace(',$', '', transport_url);
};

