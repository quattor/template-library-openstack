# Heat-related types
declaration template types/openstack/heat;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';

@documentation {
    DEFAULT section for Heat
};
type openstack_heat_defaults = {
    include openstack_DEFAULTS

    'heat_metadata_server_url' : type_hostURI
    'heat_waitcondition_server_url' : type_hostURI
    'region_name' ? string
    'region_name_for_services' ? string
    'stack_domain_admin' : string
    'stack_domain_admin_password' : string
    'stack_user_domain_name' : string
};

@documentation {
    list of Heat configuration sections
}
type openstack_heat_config = {
    'DEFAULT' : openstack_heat_defaults
    'clients_keystone' : openstack_clients_keystone
    'database' : openstack_database
    'ec2authtoken' ? openstack_ec2authtoken
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'trustee' : openstack_trustee
};
