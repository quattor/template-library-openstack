unique template features/nova/common/config;

@{
desc = directory for Nova log files. If null, no log files are produced
values = path
default = /var/log/nova
required = no
}
variable OS_NOVA_LOG_DIR ?= '/var/log/nova';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/log_dir' = OS_NOVA_LOG_DIR;
'contents/DEFAULT/state_path' = '/var/lib/nova';

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NOVA_USERNAME;
'contents/keystone_authtoken/password' = OS_NOVA_PASSWORD;

# [neutron] section
'contents/neutron' = openstack_load_config(OS_AUTH_CLIENT_MINIMAL_CONFIG);
'contents/neutron/password' = OS_NEUTRON_PASSWORD;
'contents/neutron/region_name' = OS_REGION_NAME;
'contents/neutron/username' = OS_NEUTRON_USERNAME;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# |service_user] section
'contents/service_user' = openstack_load_config(OS_AUTH_CLIENT_MINIMAL_CONFIG);
'contents/service_user/send_service_user_token' = true;
'contents/service_user/username' = OS_NOVA_USERNAME;
'contents/service_user/password' = OS_NOVA_PASSWORD;

# [upgrade_levels] section
# Require OS_NOVA_UPGRADE_LEVELS to be <= to current server version
# With version >= Zed, names restart at the beginning of the alphabet
'contents/upgrade_levels' = if ( is_defined(OS_NOVA_UPGRADE_LEVELS) ) {
    if ( (OS_NOVA_UPGRADE_LEVELS <= OPENSTACK_VERSION_NAME) ||
        (OPENSTACK_VERSION_NAME <= "liberty") ) {
        dict('compute', OS_NOVA_UPGRADE_LEVELS);
    } else {
        error(
            "OS_NOVA_UPGRADE_LEVELS (%s) must be less or equal to current OpenStack version (%s)",
            OS_NOVA_UPGRADE_LEVELS,
            OPENSTACK_VERSION_NAME,
        );
    };
} else {
    null;
};
