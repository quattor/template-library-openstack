declaration template defaults/openstack/schema/schema;

include 'defaults/openstack/schema/types';


@documentation {
    list of keystone configuration sections
}
type openstack_keystone_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'memcache' : openstack_keystone_memcache
    'revoke' : openstack_keystone_revoke
    'token' : openstack_keystone_token
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
};

@documentation {
    list of ceilometer configuration sections
}
type openstack_ceilometer_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};


@documentation {
    list of cinder configuration sections
}
type openstack_cinder_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};


@documentation {
    list of glance configuration sections
}
type openstack_glance_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};


@documentation {
    list of heat configuration sections
}
type openstack_heat_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};


@documentation {
    list of nova configuration sections
}
type openstack_nova_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};


@documentation {
    list of neutron configuration sections
}
type openstack_neutron_config = extensible {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};
