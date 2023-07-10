# Neutron-related types
declaration template types/openstack/neutron;

include 'pan/types';
include 'types/openstack/functions';

include 'types/openstack/core';

@documentation {
    Extended DEFAULT section for Neutron server
}
type openstack_neutron_server_defaults_config = {
    include openstack_DEFAULTS
    'allow_overlapping_ips': boolean = false
    'base_mac' ? type_hwaddr
    'core_plugin' ? string
    'dns_domain' ? type_fqdn
    'dvr_base_mac' ? type_hwaddr
    'notify_nova_on_port_data_changes' : boolean = true
    'notify_nova_on_port_status_changes' : boolean = true
    'service_plugins' : string[]
    'use_ssl' : boolean
};

@documentation {
    list of common neutron configuration sections
}
type openstack_neutron_base_config = {
    'DEFAULT' : openstack_DEFAULTS
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_concurrency': openstack_oslo_concurrency
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
};

@documentation {
    list of neutron configuration sections
}
type openstack_neutron_compute_config = {
    include openstack_neutron_base_config
};

@documentation {
    list of neutron network server configuration sections
}
type openstack_neutron_network_config = {
    include openstack_neutron_base_config
};

@documentation {
    list of neutron server configuration sections
}
type openstack_neutron_server_config = {
    'DEFAULT' : openstack_neutron_server_defaults_config
    'database' : openstack_database
    'keystone_authtoken' : openstack_keystone_authtoken
    'nova': openstack_keystone_authtoken
    'oslo_concurrency': openstack_oslo_concurrency
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'ssl' ?  openstack_httpd_ssl_config
};
