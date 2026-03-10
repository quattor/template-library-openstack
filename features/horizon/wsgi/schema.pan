declaration template features/horizon/wsgi/schema;

include 'types/openstack/core';
include 'types/openstack/httpd';


type openstack_dashboard_httpd_config = {
    include openstack_httpd_vhost
    'redirect_url' ? type_hostURI
    'root_url' ? type_URI
    'server_aliases' ? type_hostname[] = list()
    'server_name' : type_hostname
};
