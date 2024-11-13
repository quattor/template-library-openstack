# Add a Nginx VH for handling magnum https requests

unique template features/magnum/nginx/config;

variable OS_MAGNUM_PUBLIC_HOST ?= error('OS_MAGNUM_PUBLIC_HOST must be defined when using SSL with Magnum');
variable OS_MAGNUM_PUBLIC_PORT ?= error('OS_MAGNUM_PUBLIC_PORT must be defined when using SSL with Magnum');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Magnum
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/magnum.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/magnum.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_MAGNUM_PUBLIC_PORT;
'contents/proxy_host' = OS_MAGNUM_CONTROLLER_HOST;
'contents/proxy_port' = OS_MAGNUM_CONTROLLER_PORT;
'contents/server_name' = OS_MAGNUM_PUBLIC_HOST;
'contents/service' = 'magnum';
'contents/ssl' = openstack_load_ssl_config( true );
