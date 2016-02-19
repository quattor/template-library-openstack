unique template features/neutron/network/config;

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
include 'features/neutron/variables/' + OS_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/network/mechanism/' + OS_NEUTRON_MECHANISM;

# Include some common configuration
include 'features/neutron/common/config';

include 'features/neutron/network/agents/metadata_agent';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/service_plugins' = 'router';
'contents/DEFAULT/allow_overlapping_ips' = 'True';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/base_mac' = OS_NEUTRON_BASE_MAC;
'contents/DEFAULT/dvr_base_mac' = OS_NEUTRON_DVR_BASE_MAC;

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');
