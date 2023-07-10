declaration template features/placement/wsgi/schema;

include 'types/openstack/core';


type openstack_placement_httpd_config = {
    'log_file' : absolute_file_path = '/var/log/placement/placement-api.log'
    'port' : long(1..65535) = 8778
    'ssl' : openstack_httpd_ssl_config
};
