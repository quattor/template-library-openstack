unique template features/keystone/wsgi/config;

# Define default parameter values for processes, threads and listen-backlog
# Other parameter defaults are taken from the schema
variable OS_KEYSTONE_WSGI_PARAMS_PUBLIC = {
    if ( !is_defined(SELF['processes']) ) {
        SELF['processes'] = 15;
    };
    if ( !is_defined(SELF['threads']) ) {
        SELF['threads'] = 20;
    };
    if ( !is_defined(SELF['listen_backlog']) ) {
        SELF['listen_backlog'] = SELF['processes'] * SELF['threads'];
    };

    SELF;
};

variable OS_KEYSTONE_WSGI_PARAMS_ADMIN = {
    if ( !is_defined(SELF['processes']) ) {
        SELF['processes'] = 15;
    };
    if ( !is_defined(SELF['threads']) ) {
        SELF['threads'] = 20;
    };
    if ( !is_defined(SELF['listen_backlog']) ) {
        SELF['listen_backlog'] = SELF['processes'] * SELF['threads'];
    };

    SELF;
};


include 'features/keystone/wsgi/schema';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/keystone.conf}';
'module' = 'openstack/wsgi-keystone';
'daemons/httpd' = 'restart';
# panlint disable=LP006
bind '/software/components/metaconfig/services/{/etc/httpd/conf.d/keystone.conf}/contents' = openstack_httpd_config;

'contents/oidc_enabled' = if ( is_defined(OS_KEYSTONE_FEDERATION_OIDC_PARAMS) ) {
    true;
} else {
    false;
};

'contents/vhosts/0/bind_host' = if ( OS_HORIZON_PROTOCOL == 'https' ) OS_KEYSTONE_CONTROLLER_HOST else null;
'contents/vhosts/0/port' = OS_KEYSTONE_CONTROLLER_STANDARD_PORT;
'contents/vhosts/0/wsgi/process_group' = 'keystone-public';
'contents/vhosts/0/wsgi/script_path' = '/usr/bin';
'contents/vhosts/0/wsgi/script_name' = 'keystone-wsgi-public';
'contents/vhosts/0/wsgi' = {
    foreach (param; val; OS_KEYSTONE_WSGI_PARAMS_PUBLIC) {
        SELF[param] = val;
    };

    SELF;
};

'contents/vhosts/1/bind_host' = if ( OS_HORIZON_PROTOCOL == 'https' ) OS_KEYSTONE_CONTROLLER_HOST else null;
'contents/vhosts/1/port' = OS_KEYSTONE_CONTROLLER_ADMIN_PORT;
'contents/vhosts/1/wsgi/process_group' = 'keystone-admin';
'contents/vhosts/1/wsgi/script_path' = '/usr/bin';
'contents/vhosts/1/wsgi/script_name' = 'keystone-wsgi-admin';
'contents/vhosts/1/wsgi' = {
    foreach (param; val; OS_KEYSTONE_WSGI_PARAMS_ADMIN) {
        SELF[param] = val;
    };

    SELF;
};

'contents/listen' = {
    vhosts = value('/software/components/metaconfig/services/{/etc/httpd/conf.d/keystone.conf}/contents/vhosts');
    foreach (i; vhost; vhosts) {
        append(vhost['port']);
    };
    SELF;
};

# Load TT file to configure the keystone virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-keystone.tt}';
'config' = file_contents('features/keystone/wsgi/keystone.tt');
'perms' = '0644';

# Create the OIDC-related configuration file for Apache
include if ( is_defined(OS_KEYSTONE_FEDERATION_OIDC_PARAMS) ) 'features/keystone/wsgi/oidc';
