unique template features/neutron/base;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Neutron-related type definitions
include 'types/openstack/neutron';

# Include general openstack variables
include 'defaults/openstack/config';

# Install RPMs for compute part of neutron
include 'features/neutron/rpms/config';

# Include variables needed to configure neutron
include 'features/neutron/variables/' + OS_NEUTRON_NETWORK_TYPE;

# network driver configuration
include 'features/neutron/mechanism/' + OS_NEUTRON_MECHANISM;

include 'components/metaconfig/config';

################
# neutron.conf #
################

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;

# [DEFAULT]
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

# [oslo_concurrency] section
'contents/oslo_concurrency/lock_path' = '/var/lib/neutron/tmp';

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# Create symlink from /etc/neutron/plugins/ml2/ml2_conf.ini to /etc/neutron/plugin.ini
include 'components/symlink/config';
prefix '/software/components/symlink';
'links' = {
  SELF[length(SELF)] = dict(
    'exists', false,
    'name', '/etc/neutron/plugin.ini',
    'replace', dict( 'all', 'yes'),
    'target', '/etc/neutron/plugins/ml2/ml2_conf.ini'
  );
  SELF;
};

