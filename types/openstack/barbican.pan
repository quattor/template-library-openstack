# Barbican-related types
declaration template types/openstack/barbican;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';

@documentation {
    DEFAULT section for Barbican
}
type openstack_barbican_defaults = {
    include openstack_DEFAULTS
    'host_href' : type_hostURI
    'sql_connection': string
};

@documentation {
    list of barbican configuration sections
}
type openstack_barbican_config = {
    'DEFAULT' : openstack_barbican_defaults
    'keystone_authtoken' : openstack_keystone_authtoken
};
