declarative template features/keystone/schema/openstack;

include 'defaults/openstack/schema/types';

@documentation {
    The memcache configuration section.
}
type keystone_memcache = extensible {
    'servers' : string with match(*:*),
}

@documentation {
    The revoke configuration section
}
type keystone_revoke = extensible {
    'driver' : string,
}

@documentation {
    The token configuration section
}
type keystone_token = extensible {
    'provider' : string,
    'driver' : string,
}

@documentation {
    list of keystone configuration sections
}
type keystone_config = extensible {
    'DEFAULTS' : openstack_DEFAULTS,
    'database' : openstack_database,
    'memcache' : keystone_memcache,
    'revoke' : keystone_revoke,
    'token' : keystone_token,
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit,
};
