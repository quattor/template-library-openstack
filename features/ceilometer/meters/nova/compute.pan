# This template must be included after the Nova compute base configuration
unique template features/ceilometer/meters/nova/compute;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

include 'features/ceilometer/meters/nova/rpms/compute';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-ceilometer-compute/startstop' = true;

# Configuration file for ceilometer
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}';
'module' = 'tiny';
'daemons/openstack-ceilometer-compute'='restart';

prefix '/software/components/metaconfig/services/{/etc/ceilometer/ceilometer.conf}/contents';
# [DEFAULT] section
'DEFAULT/auth_strategy' = 'keystone';
'DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [oslo_messaging_rabbit] section
'oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [keystone_authtoken] section
'keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'keystone_authtoken/username' = OS_CEILOMETER_USERNAME;
'keystone_authtoken/password' = OS_CEILOMETER_PASSWORD;

# [service_credentials] section
'service_credentials/os_auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000/v2.0';
'service_credentials/username' = OS_CEILOMETER_USERNAME;
'service_credentials/os_tenant_name' = 'service';
'service_credentials/os_password' = OS_CEILOMETER_PASSWORD;
'service_credentials/os_endpoint_type' = 'internalURL';
'service_credentials/os_region_name' = OS_REGION_NAME;

'/software/components/metaconfig/services/{/etc/nova/nova.conf}' ?= error('%s must be included after the Nova base configuration', TEMPLATE);
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';

# [DEFAULT]section
'DEFAULT/instance_usage_audit' = true;
'DEFAULT/instance_usage_audit_period' = 'hour';
'DEFAULT/compute_monitors' = list('ComputeDriverCPUMonitor', 'cpu.virt_driver');

# [oslo_messaging_notifications] section
'oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [notifications] section
'notifications/notify_on_state_change' = 'vm_and_task_state';

# Configure snmpd for ceilometer
include 'features/ceilometer/meters/nova/snmp';
