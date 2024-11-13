unique template features/neutron/controller/config;

@{
desc = number of API workers
values = long
default = number of cores
requiered = no
}
variable OS_NEUTRON_API_WORKERS ?= value('/hardware/cpu/0/cores') * length(value('/hardware/cpu'));

@{
desc = number of RPC workers
values = long
default = number of 1
requiered = no
}
variable OS_NEUTRON_RPC_WORKERS ?= 1;

@{
desc = if false, allow to disable restart of Neutron server after a config change. Strongly discouraged.
values = boolean
default = true
required = no
}
variable OS_NEUTRON_RESTART_ON_CONFIG_CHANGE ?= true;


variable OS_NODE_SERVICES = append('neutron');

# Load Neutron base configuration
include 'features/neutron/base';

# Include common server configuration
include 'features/neutron/server';

# Include policy file if OS_NEUTRON_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('neutron', OS_NEUTRON_POLICY);


# neutron.conf
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'daemons/neutron-server' = if ( OS_NEUTRON_RESTART_ON_CONFIG_CHANGE ) {
    'restart';
} else {
    null
};
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents' = openstack_neutron_server_config;

# [DEFAULT]
'contents/DEFAULT/bind_host' = if ( OS_NEUTRON_PROTOCOL == 'https' ) {
    OS_NEUTRON_CONTROLLER_HOST;
} else {
    '0.0.0.0';
};
'contents/DEFAULT/bind_port' = OS_NEUTRON_CONTROLLER_PORT;
'contents/DEFAULT/notify_nova_on_port_status_changes' = true;
'contents/DEFAULT/notify_nova_on_port_data_changes' = true;
'contents/DEFAULT/api_workers' = OS_NEUTRON_API_WORKERS;
'contents/DEFAULT/rpc_workers' = OS_NEUTRON_RPC_WORKERS;
'contents/DEFAULT/use_ssl' = false;

# [database]
'contents/database/connection' = format(
    'mysql+pymysql://%s:%s@%s/neutron',
    OS_NEUTRON_DB_USERNAME,
    OS_NEUTRON_DB_PASSWORD,
    OS_NEUTRON_DB_HOST
);
'contents/database/max_pool_size' = OS_NEUTRON_DB_POOL_SIZE;
'contents/database/max_overflow' = OS_NEUTRON_DB_MAX_OVERFLOW;

# [nova]
'contents/nova' =  openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/nova/username' = OS_NOVA_USERNAME;
'contents/nova/password' = OS_NOVA_PASSWORD;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/neutron/tmp';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_NEUTRON_PROTOCOL == 'https' ) 'features/neutron/controller/nginx/config';
