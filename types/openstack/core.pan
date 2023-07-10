# OpenStack core types used by other components

declaration template types/openstack/core;

include 'pan/types';
include 'types/openstack/functions';

@documentation {
    The configuration options related to logging
}
type openstack_logging_config = {
    'debug' ? boolean
    'syslog_log_facility' ? string
    'use_syslog' ? boolean
};

@documentation {
    The configuration options common to all components in the DEFAULTS section
}
type openstack_DEFAULTS = {
    include openstack_logging_config
    'admin_token' ? string
    'auth_strategy' ? choice('keystone', 'noauth2') = 'keystone'
    'cert_file' ? absolute_file_path
    'enabled_tokens' ? string[]
    'key_file' ? absolute_file_path
    'log_dir' ? absolute_file_path
    'log_file' ? string
    'my_ip' ? type_ip
    'notifications' ? string
    'rpc_conn_pool_size' ? long
    'transport_url' : string with is_hostURI(SELF)
};

@documentation {
    The configuration options in the clients_keystone section
}
type openstack_clients_keystone = {
    'auth_uri' : string with is_hostURI(SELF)
    'ca_file' ? absolute_file_path
    'cert_file' ? absolute_file_path
    'key_file' ? absolute_file_path
};

@documentation {
    The configuration options in the database section
}
type openstack_database = {
    'connection' : string
    'max_pool_size' ? long
    'max_overflow' ? long
};

@documentation {
    The configuration options in the ec2authtoken section
}
type openstack_ec2authtoken = {
    'auth_uri' : string with is_hostURI(SELF)
    'ca_file' ? absolute_file_path
    'cert_file' ? absolute_file_path
    'key_file' ? absolute_file_path
};

@documentation {
    SSL-related configuration for Apache configuration
}
type openstack_httpd_ssl_config = {
    'cert_file' ? absolute_file_path
    'key_file' ? absolute_file_path
};

@documentation {
    The configuration options in the keystone_authtoken section
}
type openstack_keystone_authtoken = {
    'auth_url' : string with is_hostURI(SELF)
    'auth_type' : string
    'auth_version' ? string
    'memcached_servers' ? type_hostport[]
    'password' : string
    'project_domain_id' ? string
    'project_domain_name' ? string
    'project_name' : string
    'region_name' ? string
    'service_token_roles' ? string[]
    'username' : string
    'user_domain_id' ? string
    'user_domain_name' ? string
    'www_authenticate_uri' ? string with is_hostURI(SELF)
} with openstack_project_name_or_id(SELF);

@documentation {
    The memcache configuration section.
}
type openstack_keystone_memcache = {
    'servers' : type_hostport[]
};

@documentation {
    Configuration of a Nginx proxy in front of an OpenStack service
}
type openstack_nginx_proxy_config = {
    'bind_port' : long(1..65535)
    'proxy_host' : type_hostname
    'proxy_port' : long(1..65535)
    'server_name' : type_hostname
    'service' : string
    'ssl' : openstack_httpd_ssl_config
};


@documentation {
    The configuration options in the oslo_concurrency section
}
type openstack_oslo_concurrency = {
    'lock_path': absolute_file_path
};

@documentation {
    The configuration options in the oslo_messaging_notifications section
}
type openstack_oslo_messaging_notifications = {
    'driver': string
};

@documentation {
    The configuration options in the oslo_messaging_rabbit section
}
type openstack_oslo_messaging_rabbit = {
    'rabbit_host' ? type_hostname
    'rabbit_hosts' ? string # with match('*:*')
    'rabbit_userid' ? string
    'rabbit_password' ? string
    'rabbit_retry_interval' : long
};

@documentation {
    The configuration options in the paste_deploy section
}
type openstack_paste_deploy = {
    'flavor': string
};

@documentation {
    The configuration options in the service_credentials section
}
type openstack_service_credentials = {
    'os_auth_url' : string #with match('*://*:*')
    'username' : string
    'os_tenant_name' : string
    'os_password' : string
    'os_endpoint_type' : string
    'os_region_name' : string
};

@documentation {
    The configuration options in the trustee section
}
type openstack_trustee = {
    'auth_url' : string with is_hostURI(SELF)
    'auth_type' : string
    'password' : string
    'username' : string
    'user_domain_id' ? string
};

