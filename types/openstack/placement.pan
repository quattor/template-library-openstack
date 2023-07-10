# Placement-related types
declaration template types/openstack/placement;

include 'pan/types';
include 'types/openstack/functions';

include 'types/openstack/core';

@documentation {
    api section for Placement
}
type openstack_placement_api = {
    'auth_strategy' : choice('keystone', 'noauth2') = 'keystone'
};

@documentation {
    placement section for Placement
}
type openstack_placement_placement = {
    'incomplete_consumer_project_id' ? string
    'incomplete_consumer_user_id' ? string
    'randomize_allocation_candidates' ? boolean
};

@documentation {
    list of placement configuration sections
}
type openstack_placement_config = {
    'DEFAULT' ? openstack_DEFAULTS
    'api' : openstack_placement_api
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'placement' ? openstack_placement_placement
    'placement_database' : openstack_database
};
