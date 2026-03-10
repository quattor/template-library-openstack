# Add a Nginx VH for handling heat https requests

unique template features/heat/nginx/config;

variable OS_HEAT_PUBLIC_HOST ?= error('OS_HEAT_PUBLIC_HOST must be defined when using SSL with Heat');
variable OS_HEAT_PUBLIC_PORT ?= error('OS_HEAT_PUBLIC_PORT must be defined when using SSL with Heat');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Heat
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/heat.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/heat.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_HEAT_PUBLIC_PORT;
'contents/proxy_host' = OS_HEAT_CONTROLLER_HOST;
'contents/proxy_port' = OS_HEAT_CONTROLLER_PORT;
'contents/server_name' = OS_HEAT_PUBLIC_HOST;
'contents/service' = 'heat';
'contents/ssl' = openstack_load_ssl_config( true );
