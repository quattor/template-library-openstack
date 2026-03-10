# Add a Nginx VH for handling keystone https requests

unique template features/keystone/nginx/config;

variable OS_KEYSTONE_PUBLIC_HOST ?= error(
    'OS_KEYSTONE_PUBLIC_HOST must be defined when using SSL with Keystone'
);
variable OS_KEYSTONE_PUBLIC_STANDARD_PORT ?= error(
    'OS_KEYSTONE_PUBLIC_STANDARD_PORT must be defined when using SSL with Keystone'
);
variable OS_KEYSTONE_PUBLIC_ADMIN_PORT ?= error(
    'OS_KEYSTONE_PUBLIC_ADMIN_PORT must be defined when using SSL with Keystone'
);

include 'types/openstack/core';

# Add Nginx and its base configuration
include 'features/nginx/openstack/config';

# Nginx proxy configuration for Keystone standard (unprivileged) port
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/keystone-standard.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/keystone-standard.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_KEYSTONE_PUBLIC_STANDARD_PORT;
'contents/proxy_host' = OS_KEYSTONE_CONTROLLER_HOST;
'contents/proxy_port' = OS_KEYSTONE_CONTROLLER_STANDARD_PORT;
'contents/server_name' = OS_KEYSTONE_PUBLIC_HOST;
'contents/service' = 'keystone';
'contents/ssl' = openstack_load_ssl_config( true );

# Nginx proxy configuration for Keystone admin (privileged) port
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/keystone-admin.conf}';
'module' = 'openstack/nginx-proxy';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/keystone-admin.conf}/contents' = openstack_nginx_proxy_config;

'contents/bind_port' = OS_KEYSTONE_PUBLIC_ADMIN_PORT;
'contents/proxy_host' = OS_KEYSTONE_CONTROLLER_HOST;
'contents/proxy_port' = OS_KEYSTONE_CONTROLLER_ADMIN_PORT;
'contents/server_name' = OS_KEYSTONE_PUBLIC_HOST;
'contents/service' = 'keystone';
'contents/ssl' = openstack_load_ssl_config( true );

