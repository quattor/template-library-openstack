declarative template defaults/openstack/schema/openstack;

include 'pan/types';

@documentation {
    The configuration options in the DEFAULTS Section
}
type openstack_DEFAULTS = extensible {
    'admin_token' ? string,
    'notifications' ? string,
    'verbose' ? boolean,
    'debug' ? boolean,
    'use_syslog' ? boolean,
    'syslog_log_facility' ? string,
};

@documentation {
    The configuration options in the database Section
}
type openstack_database = extensible {
    'connection' : string;
};

@documentation {
    The configuration options in the oslo_messaging_rabbit Section
}
type openstack_oslo_messaging_rabbit = extensible {
    'rabbit_host' ? type_hostname,
    'rabbit_hosts' ? string with match(*:*),
    'rabbit_userid' ? string,
    'rabbit_password' ? string,
};
