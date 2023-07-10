declaration template features/dashboard/wsgi/schema;

include 'types/openstack/core';


type openstack_dashboard_httpd_config = {
    'root_url' ? type_URI
    'server_aliases' ? type_hostname[] =list()
    'server_name' : type_hostname
    'ssl' : openstack_httpd_ssl_config
};
