unique template features/neutron/network/config;

include 'defaults/openstack/schema/schema';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/neutron/network/rpms/config';

# Configure some usefull package for neutron
#include 'features/httpd/config';
#include 'features/memcache/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OPENSTACK_NEUTRON_MECHANISM + '/' + OPENSTACK_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/network/mechanism/' + OPENSTACK_NEUTRON_MECHANISM;

# Include some common configuration
include 'features/neutron/common/config';

include 'features/neutron/network/agents/metadata_agent';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

include 'components/metaconfig/config';

bind '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}/contents' = openstack_neutron_config;

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/service_plugins' = 'router';
'contents/DEFAULT/allow_overlapping_ips' = 'True';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/base_mac' = OPENSTACK_NEUTRON_BASE_MAC;
'contents/DEFAULT/dvr_base_mac' = OPENSTACK_NEUTRON_DVR_BASE_MAC;
'contents/DEFAULT/notification_driver' = 'messagingv2';

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OPENSTACK_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OPENSTACK_NEUTRON_PASSWORD;

#[oslo_messaging_rabbit] section
'contents/DEFAULT' = openstack_load_config('features/rabbitmq/client/openstack');
