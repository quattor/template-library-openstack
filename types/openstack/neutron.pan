# Neutron-related types
declaration template types/openstack/neutron;

include 'pan/types';
include 'types/openstack/types';

include 'types/openstack/core';

@documentation {
    Extended DEFAULT section for Neutron server
}
type openstack_neutron_server_defaults_config = {
    include openstack_DEFAULTS
    'allow_overlapping_ips': boolean = false
    'api_workers' ? long
    'base_mac' ? type_hwaddr
    'bind_host' : type_hostname
    'bind_port' : type_port
    'core_plugin' ? string
    'dns_domain' ? type_fqdn
    'dvr_base_mac' ? type_hwaddr
    'notify_nova_on_port_data_changes' : boolean = true
    'notify_nova_on_port_status_changes' : boolean = true
    'rpc_workers' ? long
    'service_plugins' : string[]
    'use_ssl' : boolean
};

@documentation {
    parameters for neutron [experimental] section
}
type openstack_neutron_experimental = {
    'linuxbridge' ? boolean = false
};

@documentation {
    list of common neutron configuration sections
}
type openstack_neutron_base_config = {
    'experimental' ? openstack_neutron_experimental
    'keystone_authtoken' : openstack_keystone_authtoken
    'oslo_concurrency': openstack_oslo_concurrency
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
};

@documentation {
    list of neutron compute configuration sections
}
type openstack_neutron_compute_config = {
    include openstack_neutron_base_config

    'DEFAULT' : openstack_DEFAULTS
};

@documentation {
    list of neutron network server configuration sections
}
type openstack_neutron_network_config = {
    include openstack_neutron_base_config

    'DEFAULT' : openstack_DEFAULTS
};

@documentation {
    list of neutron server configuration sections
}
type openstack_neutron_server_config = {
    include openstack_neutron_base_config

    'DEFAULT' : openstack_neutron_server_defaults_config
    'database' : openstack_database
    'nova': openstack_keystone_authtoken
    'ssl' ?  openstack_httpd_ssl_config
};
