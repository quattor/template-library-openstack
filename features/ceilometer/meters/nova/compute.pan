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
'daemons/openstack-ceilometer-compute'='restart';

# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_CEILOMETER_USERNAME;
'contents/keystone_authtoken/password' = OS_CEILOMETER_PASSWORD;

# [service_credentials] section
'contents/service_credentials/os_auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000/v2.0';
'contents/service_credentials/username' = OS_CEILOMETER_USERNAME;
'contents/service_credentials/os_tenant_name' = 'service';
'contents/service_credentials/os_password' = OS_CEILOMETER_PASSWORD;
'contents/service_credentials/os_endpoint_type' = 'internalURL';
'contents/service_credentials/os_region_name' = OS_REGION_NAME;

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'daemons/openstack-nova-compute'='restart';

# [DEFAULT] section
'contents/DEFAULT/instance_usage_audit' = 'True';
'contents/DEFAULT/instance_usage_audit_period' = 'hour';
'contents/DEFAULT/notify_on_state_change' = 'vm_and_task_state';
'contents/DEFAULT/notification_driver' = 'messagingv2';
