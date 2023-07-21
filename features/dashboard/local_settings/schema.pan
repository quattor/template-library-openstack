declaration template features/dashboard/local_settings/schema;

include 'types/openstack/core';

type openstack_dashboard_django_keystone_config = {
    'api_version' : long(1..3) = 3
    'default_domain' : string = 'default'
    'host' : type_hostname
    'multidomain' : boolean
    'port' : long(1..65535) = 5000
    'protocol' : choice('http', 'https') = 'https'
};

type openstack_dashboard_launch_instance_config = {
    'config_drive' : boolean = false
    'create_volume' : boolean = false
    'disable_image' : boolean = false
    'disable_instance_snapshot' : boolean = false
    'disable_volume' : boolean = false
    'disable_volume_snapshot' : boolean = false
    'enable_scheduler_hints' : boolean = true
    'hide_create_volume' : boolean = false
};

type openstack_dashboard_django_config = {
    'allowed_hosts' : type_hostname[]
    'cloud_timezone' : string = "UTC"
    'keystone' : openstack_dashboard_django_keystone_config
    'launch_instance' ? openstack_dashboard_launch_instance_config
    'policy_files_path' : absolute_file_path = "/etc/openstack-dashboard"
    'role' : string
    'root_url' : type_URI
    'secret_key' : string
};
