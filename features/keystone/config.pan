unique template features/keystone/config;

variable OS_NODE_SERVICES = append('keystone');

# Load some useful functions
include 'defaults/openstack/functions';

# Load Keystone-related type definitions
include 'types/openstack/keystone';

# Include general openstack variables
include 'defaults/openstack/config';


@{
desc = if false disable credential tokens. Use only for transionning from false to true.
values = boolean
default = true
requied = no
}
variable OS_KEYSTONE_CREDENTIAL_TOKENS ?= true;

@{
desc = define Fernet token max expected size... With a LDAP backend, longer than the 255 \
       default. See https://bugs.launchpad.net/keystone/+bug/1926483. 
values = long
default = 300
requied = no
}
variable OS_KEYSTONE_TOKEN_MAX_SIZE ?= 300;

@{
desc = define the list of autentication methods allowed
values = list of strings (see schema for allowed values) or null for OpenStack default
default = see below
requied = no
}
variable OS_KEYSTONE_AUTH_METHODS ?= list('application_credential', 'password', 'token');


@{
desc = OIDC parameters
values = dict
default = undef
requied = no
}
variable OS_KEYSTONE_FEDERATION_OIDC_PARAMS ?= undef;


# Include policy file if OS_KEYSTONE_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('keystone', OS_KEYSTONE_POLICY);


include 'features/keystone/rpms';

#  httpd configuration
# httpd is used instead of uwsgi because federation identity requires mod_openidc
include 'features/httpd/openstack/config';
include 'features/keystone/wsgi/config';

# memcache configuration
include 'features/memcache/config';

# Configuration file for keystone
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/httpd' = 'restart';
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}/contents' = openstack_keystone_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/admin_token' ?= OS_ADMIN_TOKEN;
# Remove unsupported parameters
'contents/DEFAULT/auth_strategy' = null;
'contents/DEFAULT/log_file' = 'keystone.log';
'contents/DEFAULT/log_dir' = '/var/log/keystone';
'contents/DEFAULT/max_token_size' = if ( is_defined(OS_KEYSTONE_TOKEN_MAX_SIZE) ) {
    OS_KEYSTONE_TOKEN_MAX_SIZE;
} else {
    null;
};

# [auth] section
'contents/auth/methods' = {
    # OS_KEYSTONE_AUTH_METHODS is expected to be a list or to be null
    methods = OS_KEYSTONE_AUTH_METHODS;
    if ( is_defined(OS_KEYSTONE_FEDERATION_OIDC_PARAMS) ) {
        methods[length(methods)] = 'openid';
    };

    methods;
};

# [cache] section
'contents/cache/memcache_servers' = list(OS_MEMCACHE_HOST + ':11211');
'contents/cache/enabled' = true;
'contents/cache/backend' = 'oslo_cache.memcache_pool';

# [credentials] section
'contents/credentials' = if ( OS_KEYSTONE_CREDENTIAL_TOKENS ) {
    dict('key_repository', '/etc/keystone/credentials-keys');
} else {
    null;
};

# [database] section
'contents/database/connection' = format(
    'mysql+pymysql://%s:%s@%s/keystone',
    OS_KEYSTONE_DB_USERNAME,
    OS_KEYSTONE_DB_PASSWORD,
    OS_KEYSTONE_DB_HOST
);

# [federation] section
'contents/federation' = if ( is_defined(OS_KEYSTONE_FEDERATION_OIDC_PARAMS) && is_defined(OS_HORIZON_PUBLIC_NAMES)) {
    SELF['trusted_dashboard'] = list();
    foreach (host; public; OS_HORIZON_PUBLIC_NAMES) {
        SELF['trusted_dashboard'][length(SELF['trusted_dashboard'])] = format(
            # panlint disable=PP001
            'https://%s%s/auth/websso/',
            public, OS_HORIZON_ROOT_URL
        );
    };
    SELF;
} else {
    null;
};

# [fernet_tokens] section
'contents/fernet_tokens/key_repository' = '/etc/keystone/fernet-keys';

# [memcache] section
'contents/memcache/servers' = list(OS_MEMCACHE_HOST + ':11211');

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [token] section
'contents/token/provider' = 'fernet';

# Configure identity backend
include 'features/keystone/identity/' + OS_KEYSTONE_IDENTITY_DRIVER;


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' ) 'features/keystone/nginx/config';

