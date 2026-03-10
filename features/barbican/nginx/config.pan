# Add a Nginx VH for handling barbican https requests

unique template features/barbican/nginx/config;

variable OS_BARBICAN_PUBLIC_HOST ?= error('OS_BARBICAN_PUBLIC_HOST must be defined when using SSL with Barbican');
variable OS_BARBICAN_PUBLIC_PORT ?= error('OS_BARBICAN_PUBLIC_PORT must be defined when using SSL with Barbican');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Barbican
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/barbican.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/barbican.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_BARBICAN_PUBLIC_PORT;
'contents/proxy_host' = OS_BARBICAN_CONTROLLER_HOST;
'contents/proxy_port' = OS_BARBICAN_CONTROLLER_PORT;
'contents/server_name' = OS_BARBICAN_PUBLIC_HOST;
'contents/service' = 'barbican';
'contents/ssl' = openstack_load_ssl_config( true );
