# Add a Nginx VH for handling octavia https requests

unique template features/octavia/nginx/config;

variable OS_OCTAVIA_PUBLIC_HOST ?= error('OS_OCTAVIA_PUBLIC_HOST must be defined when using SSL with Octavia');
variable OS_OCTAVIA_PUBLIC_PORT ?= error('OS_OCTAVIA_PUBLIC_PORT must be defined when using SSL with Octavia');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Octavia
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/octavia.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/octavia.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_OCTAVIA_PUBLIC_PORT;
'contents/proxy_host' = OS_OCTAVIA_CONTROLLER_HOST;
'contents/proxy_port' = OS_OCTAVIA_CONTROLLER_PORT;
'contents/server_name' = OS_OCTAVIA_PUBLIC_HOST;
'contents/service' = 'octavia';
'contents/ssl' = openstack_load_ssl_config( true );
