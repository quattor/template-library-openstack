unique template features/nova/compute/policy/config;

# Load TT file to configure Nova policy file
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/nova-policy.tt}';
'config' = file_contents('features/nova/compute/policy/policy.tt');

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/policy.json}';
'module' = 'openstack/nova-policy';
'contents' = dict();
