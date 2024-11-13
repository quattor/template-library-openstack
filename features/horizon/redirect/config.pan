# Template to redirect the dashboard to another server after moving it
unique template features/horizon/redirect/config;

@{
desc = list of FQDN used to access Horizon on the current server
values = list of strings
default = empty list
required = no
}
variable OS_HORIZON_ALIAS_NAMES ?= list();

include 'features/horizon/wsgi/schema';

prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/horizon.conf}';
include 'components/metaconfig/config';
'module' = 'openstack/horizon-redirect';
'daemons/nginx' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/nginx/conf.d/horizon.conf}/contents' = openstack_dashboard_httpd_config;

'contents/port' = OS_HORIZON_PUBLIC_PORT;
'contents/redirect_url' = format('%s://%s:%s', OS_HORIZON_PROTOCOL, OS_HORIZON_NEW_HOST, OS_HORIZON_PUBLIC_PORT);
'contents/server_aliases' = OS_HORIZON_ALIAS_NAMES;
'contents/server_name' = FULL_HOSTNAME;
'contents/ssl' = openstack_load_ssl_config( OS_HORIZON_PROTOCOL == 'https' );
# Useless but required by schema
'contents/wsgi/process_group' = 'horizon';
'contents/wsgi/script_path' = '/usr/share/openstack-dashboard';
'contents/wsgi/script_name' = 'openstack_dashboard/wsgi.py';

# Load TT file to configure the dashboard virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/horizon-redirect.tt}';
'config' = file_contents('features/horizon/redirect/horizon.tt');
'perms' = '0644';

# Redirect port 80 to the new Horizon server
prefix '/software/components/metaconfig/services/{/etc/nginx/conf.d/port_80.conf}';
'contents/redirect_urls' = if ( OS_HORIZON_USER_URL == OS_HORIZON_ROOT_URL ) {
    null;
} else {
    append(dict(
        'url', OS_HORIZON_USER_URL,
        'target', format('%s://%s:%s', OS_HORIZON_PROTOCOL, OS_HORIZON_NEW_HOST, OS_HORIZON_PUBLIC_PORT),
    ));
};
