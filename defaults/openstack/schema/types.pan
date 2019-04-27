declaration template defaults/openstack/schema/types;

include 'pan/types';

@documentation {
        The memcache configuration section.
}
type openstack_keystone_memcache = extensible {
        'servers' : string #with match('*:*')
};

@documentation {
        The revoke configuration section
}
type openstack_keystone_revoke = extensible {
        'driver' : string
};

@documentation {
        The token configuration section
}
type openstack_keystone_token = extensible {
        'provider' : string
        'driver' : string
};

@documentation {
        Checks if a string matches True or False
}
type True_False = string with match(SELF, "^(True|False)$");

@documentation {
        The configuration options in the DEFAULTS Section
}
type openstack_DEFAULTS = extensible {
        'admin_token' ? string
        'notifications' ? string
        'verbose' ? True_False
        'debug' ? True_False
        'use_syslog' ? True_False
        'syslog_log_facility' ? string
        'rpc_backend' ? string
        'auth_strategy' ? string
        'my_ip' ? type_ip
        'cert_file' ? string
        'key_file' ? string
        'sql_connection' ? string
        'transport_url' ? string
};

@documentation {
        The configuration options in the database Section
}
type openstack_database = extensible {
        'connection' : string
};

@documentation {
        The configuration options in the oslo_messaging_rabbit Section
}
type openstack_oslo_messaging_rabbit = extensible {
        'rabbit_host' ? type_hostname
        'rabbit_hosts' ? string # with match('*:*')
        'rabbit_userid' ? string
        'rabbit_password' ? string
};

@documentation {
        The configuration options in the keystone_authtoken Section
}
type openstack_keystone_authtoken = extensible {
        'username' : string
        'password' : string
        'www_authenticate_uri' : string #with match('*://*:*')
        'auth_url' : string #with match('*://*:*')
        'auth_plugin' : string
        'project_domain_name' : string
        'user_domain_name' : string
        'project_name' : string
        'auth_type' : string
};

@documentation {
        The configuration options in the service_credentials Section
}
type openstack_service_credentials = extensible {
        'os_auth_url' : string #with match('*://*:*')
        'username' : string
        'os_tenant_name' : string
        'os_password' : string
        'os_endpoint_type' : string
        'os_region_name' : string
};

@documentation {
        The configuraiton options in the simple_crypto_plugin Section
}
type openstack_simple_crypto_plugin = extensible {
        'kek' : string
};

