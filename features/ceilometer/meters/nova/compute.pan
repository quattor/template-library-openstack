unique template features/ceilometer/meters/nova/compute;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/ceilometer/meters/nova/rpms/compute';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-ceilometer-compute/on' = '';
'openstack-ceilometer-compute/startstop' = true;

# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
'daemons/openstack-ceilometer-compute' = 'restart';

# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_CEILOMETER_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_CEILOMETER_PASSWORD;

# [service_credentials] section
'contents/service_credentials/os_auth_url' = format(
    '%s/%s',
    openstack_generate_uri(
        OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL,
        OPENSTACK_KEYSTONE_SERVERS,
        OPENSTACK_KEYSTONE_PORT
        ),
    'v2.0'
);
'contents/service_credentials/username' = OPENSTACK_CEILOMETER_USERNAME;
'contents/service_credentials/os_tenant_name' = 'service';
'contents/service_credentials/os_password' = OPENSTACK_CEILOMETER_PASSWORD;
'contents/service_credentials/os_endpoint_type' = 'internalURL';
'contents/service_credentials/os_region_name' = OPENSTACK_REGION_NAME;

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'daemons/openstack-nova-compute' = 'restart';

# [DEFAULT] section
'contents/DEFAULT/instance_usage_audit' = 'True';
'contents/DEFAULT/instance_usage_audit_period' = 'hour';
'contents/DEFAULT/notify_on_state_change' = 'vm_and_task_state';
'contents/DEFAULT/notification_driver' = 'messagingv2';
'contents/DEFAULT/compute_monitors' = 'ComputeDriverCPUMonitor,cpu.virt_driver';

# Configure snmpd for ceilometer
include 'features/ceilometer/meters/nova/snmp';
