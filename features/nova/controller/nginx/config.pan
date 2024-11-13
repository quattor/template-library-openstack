# Add a Nginx VH for handling nova https requests

unique template features/nova/controller/nginx/config;

variable OS_NOVA_PUBLIC_HOST ?= error('OS_NOVA_PUBLIC_HOST must be defined when using SSL with Nova');
variable OS_NOVA_PUBLIC_PORT ?= error('OS_NOVA_PUBLIC_PORT must be defined when using SSL with Nova');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Nova API
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/nova-api.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/nova-api.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_NOVA_PUBLIC_PORT;
'contents/proxy_host' = OS_NOVA_CONTROLLER_HOST;
'contents/proxy_port' = OS_NOVA_CONTROLLER_PORT;
'contents/server_name' = OS_NOVA_PUBLIC_HOST;
'contents/service' = 'nova';
'contents/ssl' = openstack_load_ssl_config( true );

# Nginx proxy configuration for Nova noVNC proxy
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/nova-novnc.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/nova-novnc.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_NOVA_NOVNC_PUBLIC_PORT;
'contents/proxy_host' = OS_NOVA_NOVNC_CONTROLLER_HOST;
'contents/proxy_port' = OS_NOVA_NOVNC_CONTROLLER_PORT;
'contents/server_name' = OS_NOVA_NOVNC_PUBLIC_HOST;
'contents/service' = 'nova-novnc';
'contents/ssl' = openstack_load_ssl_config( true );
'contents/websocket' = true;
