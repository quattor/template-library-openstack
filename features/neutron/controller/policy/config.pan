unique template features/neutron/controller/policy/config;

# Load TT file to configure Neutron policy file
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/neutron-policy.tt}';
'config' = file_contents('features/neutron/controller/policy/policy.tt');

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/policy.json}';
'module' = 'openstack/neutron-policy';
'contents' = dict();
