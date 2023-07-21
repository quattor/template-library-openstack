# Add a Nginx VH for handling glance https requests

unique template features/glance/nginx/config;

variable OS_GLANCE_PUBLIC_HOST ?= error('OS_GLANCE_PUBLIC_HOST must be defined when using SSL with Glance');
variable OS_GLANCE_PUBLIC_PORT ?= error('OS_GLANCE_PUBLIC_PORT must be defined when using SSL with Glance');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Glance
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/glance.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/glance.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_GLANCE_PUBLIC_PORT;
'contents/proxy_host' = OS_GLANCE_CONTROLLER_HOST;
'contents/proxy_port' = OS_GLANCE_CONTROLLER_PORT;
'contents/server_name' = OS_GLANCE_PUBLIC_HOST;
'contents/service' = 'glance';
'contents/ssl' = openstack_load_ssl_config( true );

# Define bind port used by Glance and its public endpoint
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'contents/DEFAULT/bind_port' = OS_GLANCE_CONTROLLER_PORT;
'contents/DEFAULT/public_endpoint' = format('https://%s:%s', OS_GLANCE_PUBLIC_HOST, OS_GLANCE_PUBLIC_PORT);
