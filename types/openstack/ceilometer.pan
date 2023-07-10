# Ceilemeter-related types
declaration template types/openstack/ceilometer;

include 'pan/types';
include 'types/openstack/functions';

include 'types/openstack/core';

@documentation {
    list of ceilometer configuration sections
}
type openstack_ceilometer_config = {
    'DEFAULT' : openstack_DEFAULTS
    'database' : openstack_database
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'keystone_authtoken' : openstack_keystone_authtoken
    'service_credentials' : openstack_service_credentials
};
