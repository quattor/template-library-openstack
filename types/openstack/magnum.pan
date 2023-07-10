# Magnum-related types
declaration template types/openstack/magnum;

include 'pan/types';
include 'types/openstack/functions';

include 'types/openstack/core';

@documentation {
    api section for Magnum
}
type openstack_magnum_api = {
    'enable_ssl' : boolean = false
    'host' : string
    'port' ? long
    'ssl_cert_file' ? absolute_file_path
    'ssl_key_file' ? absolute_file_path
} with if ( SELF['enable_ssl'] && (!is_defined(SELF['ssl_cert_file']) || !is_defined('ssl_key_file')) ) error('SSL cerficate and key are required when SSL is enabled') else true;

@documentation {
    certificates section for Magnum
}
type openstack_magnum_certificates = {
    'cert_manager_type' ? choice('barbican') = 'barbican'
};

@documentation {
    cinder section for Magnum
}
type openstack_magnum_cinder = {
    'default_docker_volume_type' ? string
    'default_etcd_volume_type' ? string
    'default_boot_volume_type' ? string
    'default_boot_volume_size' ? long = 0
};

@documentation {
    cinder_client section for Magnum
}
type openstack_magnum_cinder_client = {
    'region_name' : string
};

@documentation {
    heat_client section for Magnum
}
type openstack_magnum_heat_client = {
    'region_name' : string
};

@documentation {
    keystone_authtoken section for Magnum
    It is an extended version of the base openstack_keystone_authtoken
    Main source of information arre:
       - https://docs.openstack.org/magnum/latest/install/install-guide-from-source.html
       - https://docs.openstack.org/magnum/latest/configuration/sample-config.html
}
type openstack_magnum_keystone_authtoken = {
    include openstack_keystone_authtoken
    'admin_password' : string
    'admin_user' : string
    'admin_tenant_name' : string
};

@documentation {
    trust section for Magnum
}
type openstack_magnum_trust = {
    'cluster_user_trust' : boolean
    'roles' ? string[]
    'trustee_domain_admin_name' : string
    'trustee_domain_admin_password' : string
    'trustee_domain_name' : string
    'trustee_keysone_interface' : string = 'public'
};


@documentation {
    list of magnum configuration sections
}
type openstack_magnum_config = {
    'DEFAULT' : openstack_DEFAULTS
    'api' : openstack_magnum_api
    'certificates' : openstack_magnum_certificates
    'cinder' : openstack_magnum_cinder
    'cinder_client' : openstack_magnum_cinder_client
    'database' : openstack_database
    'heat_client' : openstack_magnum_heat_client
    'keystone_auth' : openstack_keystone_authtoken
    'keystone_authtoken' : openstack_magnum_keystone_authtoken
    'oslo_messaging_notifications' ? openstack_oslo_messaging_notifications
    'oslo_messaging_rabbit' ? openstack_oslo_messaging_rabbit
    'trust' : openstack_magnum_trust
};
