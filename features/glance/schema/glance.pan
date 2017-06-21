declarative template features/ceilometer/schema;

include 'defaults/openstack/schema/types';

@documentation {
        list of ceilometer configuration sections
}
type openstack_ceilometer_config = extensible {
        'DEFAULTS' : openstack_DEFAULTS,
        'database' : openstack_database,
        'oslo_messaging_rabbit' : openstack_oslo_messaging_rabbit,
        'keystone_authtoken' : openstack_keystone_authtoken,
        'service_credentials' : openstack_service_credentials,
};
