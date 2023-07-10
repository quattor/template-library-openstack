# Add a Nginx VH for handling cinder https requests

unique template features/cinder/nginx/config;

variable OS_CINDER_PUBLIC_HOST ?= error('OS_CINDER_PUBLIC_HOST must be defined when using SSL with Cinder');
variable OS_CINDER_PUBLIC_PORT ?= error('OS_CINDER_PUBLIC_PORT must be defined when using SSL with Cinder');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Glance
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/cinder.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/cinder.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_CINDER_PUBLIC_PORT;
'contents/proxy_host' = OS_CINDER_CONTROLLER_HOST;
'contents/proxy_port' = OS_CINDER_CONTROLLER_PORT;
'contents/server_name' = OS_CINDER_PUBLIC_HOST;
'contents/service' = 'cinder';
'contents/ssl' = openstack_load_ssl_config( true );

# Define bind port used by Cinder and its public endpoint
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'contents/DEFAULT/osapi_volume_listen_port' = OS_CINDER_CONTROLLER_PORT;
'contents/DEFAULT/public_endpoint' = format('https://%s:%s', OS_CINDER_PUBLIC_HOST, OS_CINDER_PUBLIC_PORT);
