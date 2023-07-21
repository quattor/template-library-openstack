# Glance-related types
declaration template types/openstack/glance;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';

@documentation {
    DEFAULT section for Glance
};
type openstack_glance_defaults = {
    include openstack_DEFAULTS

    'bind_port' ? long(1..65535)
    'enabled_backends' ? string[]
    'location_strategy' ? choice('location_order', 'store_type')
    'public_endpoint' ? type_hostURI
    'show_image_direct_url' ? boolean = false
    'show_multiple_locations' ? boolean
    'workers' ? long

};

@documentation {
    Paramaters for glance-api.conf glance_store section
}
type openstack_glance_store = {
    'default_backend' : string
    'stores' ? string[]
    'filesystem_store_datadir' ? absolute_file_path
};

@documentation {
    Parameters for glance-api.conf store_type_location_strategy section
}
type openstack_glance_store_type_location_strategy = {
    'store_type_preference' : string[]
};

@documentation {
    Parameters for glance-api.conf taskflow_executor section
}
type openstack_glance_taskflow_executor = {
    'max_workers' ? long
};

# openstack_glance_api_config needs to be extensible as there is one section
# per backend whose name is not known in advance
@documentation {
    list of glance configuration sections
}
type openstack_glance_api_config = extensible {
    'DEFAULT' : openstack_glance_defaults
    'database' : openstack_database
    'glance_store' : openstack_glance_store
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_messaging_notifications' : openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'paste_deploy' : openstack_paste_deploy
    'store_type_location_strategy' ? openstack_glance_store_type_location_strategy
};
