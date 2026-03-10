# Add a Nginx VH for handling horizon https requests

unique template features/horizon/nginx/config;

variable OS_HORIZON_HOST ?= error('OS_HORIZON_HOST must be defined when using SSL with Horizon');
variable OS_HORIZON_PUBLIC_PORT ?= error('OS_HORIZON_PUBLIC_PORT must be defined when using SSL with Horizon');

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Horizon
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/horizon.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/horizon.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_HORIZON_PUBLIC_PORT;
'contents/proxy_port' = OS_HORIZON_INTERNAL_PORT;
'contents/server_name' = OS_HORIZON_HOST;
'contents/service' = 'horizon';
'contents/ssl' = openstack_load_ssl_config( true );

# Redirect port 80 to the dashboard
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/port_80.conf}';
'contents/redirect_urls' = append(dict(
    'url', OS_HORIZON_USER_URL,
    'target', format('%s://%s:%s', OS_HORIZON_PROTOCOL, OS_HORIZON_HOST, OS_HORIZON_PUBLIC_PORT),
));
