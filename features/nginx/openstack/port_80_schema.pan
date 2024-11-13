unique template features/nginx/openstack/port_80_schema;

type openstack_nginx_redirect_entry = {
    'target' : type_hostURI
    'url' : type_URI
};

@documentation {
    Configuration of a Nginx VH used to handle port 80 requests
    Configuration restricted to certificate ACMPE protocol by default
}
type openstack_nginx_port_80_config = {
    'acme_challenge_url' ? type_URI
    'server_name' : type_hostname
    'server_aliases' ? string[]
    'service' : string = 'port_80'
    'redirect_urls' ? openstack_nginx_redirect_entry[]
};

