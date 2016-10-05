unique template features/nova/compute/policy;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/nova-policy.tt}';
'config' = file_contents('features/nova/compute/metaconfig/policy.tt');

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/policy.json}';
'module' = 'openstack/nova-policy';
'contents' = dict();
