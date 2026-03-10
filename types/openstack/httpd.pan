declaration template types/openstack/httpd;

@{
    WSGI parameters for vhost
    All parameters are required to simplify the TT file
    Default values are appropriate for Keystone
}
type openstack_httpd_wsgi_config = {
    'deadlock_timeout' : long = 60
    'display_name' : string = '%(GROUP)'
    'eviction_timeout' : long = 0
    'graceful_timeout' : long = 15
    'group' : string = 'keystone'
    'inactivity_timeout' : long = 0
    'listen_backlog' : long = 100
    'maximum_requests' : long = 0
    'process_group' : string
    'processes' : long = 15
    'queue_timeout' : long = 45
    'request_timeout' : long = 60
    'script_name' : string
    'script_path' : absolute_file_path
    'threads' : long = 20
    'user' : string = 'keystone'
};

@{
    Configuration of a httpd vhost
}
type openstack_httpd_vhost = {
    'bind_host' : type_hostname = '0.0.0.0'
    'port' : type_port
    'ssl' ? openstack_httpd_ssl_config
    'wsgi' ? openstack_httpd_wsgi_config
};

@{
    httpd configurtion
}
type openstack_httpd_config = {
    'listen' : type_port[]
    'oidc_enabled' : boolean = false
    'vhosts' : openstack_httpd_vhost[]
};

