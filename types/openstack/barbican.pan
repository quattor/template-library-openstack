# Barbican-related types
declaration template types/openstack/barbican;

include 'pan/types';
include 'types/openstack/functions';

include 'types/openstack/core';

@documentation {
    DEFAULT section for RBarbican
}
type openstack_barbican_defaults = {
    include openstack_DEFAULTS
    'host_href' : string with is_hostURI(SELF)
    'sql_connection': string
};

@documentation {
    list of barbican configuration sections
}
type openstack_barbican_config = {
    'DEFAULT' : openstack_barbican_defaults
    'keystone_authtoken' : openstack_keystone_authtoken
};
