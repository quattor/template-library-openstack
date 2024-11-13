# Add a Nginx VH for handling placement https requests

unique template features/placement/nginx/config;

variable OS_PLACEMENT_PUBLIC_HOST ?= error('OS_PLACEMENT_PUBLIC_HOST must be defined when using SSL with Placement');
variable OS_PLACEMENT_PUBLIC_PORT ?= error('OS_PLACEMENT_PUBLIC_PORT must be defined when using SSL with Placement');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Placement
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/placement.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/placement.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_PLACEMENT_PUBLIC_PORT;
'contents/proxy_host' = OS_PLACEMENT_CONTROLLER_HOST;
'contents/proxy_port' = OS_PLACEMENT_CONTROLLER_PORT;
'contents/server_name' = OS_PLACEMENT_PUBLIC_HOST;
'contents/service' = 'placement';
'contents/ssl' = openstack_load_ssl_config( true );
