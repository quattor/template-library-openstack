# Template to configure Nbinx port 80 to handle certificate ACME protocol

unique template features/nginx/openstack/port_80;

include 'features/nginx/openstack/port_80_schema';

# Load TT file to configure the port 80 virtual host, used in particular by certificate ACME protocol
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/nginx-port-80.tt}';
'config' = file_contents('features/nginx/openstack/port_80.tt');
'perms' = '0644';

# Nginx configuration for port 80 virtual host
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/port_80.conf}';
'module' = 'openstack/nginx-port-80';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/port_80.conf}/contents' = openstack_nginx_port_80_config;

# Adding server FQDN is enough to ask a certificate for this name and aliases
'contents/server_name' = FULL_HOSTNAME;
'contents/acme_challenge_url' = OS_SSL_ACME_CHALLENGE_URL;
