# Add a Nginx VH for handling neutron https requests

unique template features/neutron/controller/nginx/config;

variable OS_NEUTRON_PUBLIC_HOST ?= error('OS_NEUTRON_PUBLIC_HOST must be defined when using SSL with Neutron');
variable OS_NEUTRON_PUBLIC_PORT ?= error('OS_NEUTRON_PUBLIC_PORT must be defined when using SSL with Neutron');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/neutron-server.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/neutron-server.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_NEUTRON_PUBLIC_PORT;
'contents/proxy_host' = OS_NEUTRON_CONTROLLER_HOST;
'contents/proxy_port' = OS_NEUTRON_CONTROLLER_PORT;
'contents/server_name' = OS_NEUTRON_PUBLIC_HOST;
'contents/service' = 'neutron';
'contents/ssl' = openstack_load_ssl_config( true );
