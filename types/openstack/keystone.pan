# Keystone-related types
declaration template types/openstack/keystone;

include 'pan/types';
include 'types/openstack/functions';

include 'types/openstack/core';

@documentation {
    Extended DEFAULT section for the Keystone service
}
type openstack_keystone_DEFAULTS = {
    include openstack_DEFAULTS
    'max_token_size' : long = 255
};

@documentation {
    The cache options for the Keystone service
}
type openstack_keystone_cache = {
    'backend' ? choice('dogpile.cache.bmemcached',
                       'dogpile.cache.dbm',
                       'dogpile.cache.memcached',
                       'dogpile.cache.memory',
                       'dogpile.cache.memory_pickle',
                       'dogpile.cache.null',
                       'dogpile.cache.pylibmc',
                       'dogpile.cache.redis',
                       'oslo_cache.dict',
                       'oslo_cache.etcd3gw',
                       'oslo_cache.memcache_pool',
                       'oslo_cache.mongo') = 'dogpile.cache.null'
    'enabled' ? boolean = true
    'memcache_servers' ? type_hostport[]
};

@documentation {
    The fernet toeken options for the Keystone service
}
type openstack_keystone_fernet_tokens = {
    'key_repository' ? absolute_file_path = '/etc/keystone/fernet-keys'
};

@documentation {
    The identity options for the Keystone service
}
type openstack_keystone_identity = {
    'domain_config_dir' ? absolute_file_path = 'absolute_file_path'
    'domain_specific_drivers_enabled' ? boolean = false
};

@documentation {
    The revoke options for the Keystone service
}
type openstack_keystone_revoke = {
    'driver' : string
};

@documentation {
    The token options for Keystone service
}
type openstack_keystone_token = {
    'provider' : string
};

@documentation {
    list of keystone configuration sections
}
type openstack_keystone_config = {
    'DEFAULT' : openstack_keystone_DEFAULTS
    'cache' : openstack_keystone_cache
    'database' : openstack_database
    'fernet_tokens' : openstack_keystone_fernet_tokens
    'identity' : openstack_keystone_identity
    'memcache' : openstack_keystone_memcache
    'revoke' ? openstack_keystone_revoke
    'token' ? openstack_keystone_token
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
};
