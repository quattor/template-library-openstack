# Magnum fixes for supporting recent K8s versions
# Fixes must be applied with patch command
unique template features/magnum/k8s-fragment-fixes;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';

# auto-scaling patch
# panlint disable=LP006
prefix '{/usr/lib/python3.9/site-packages/magnum/drivers/common/templates/kubernetes/fragments/enable-auto-scaling.sh.patch}';
'config' = file_contents('features/magnum/magnum-k8s-fixes/enable-auto-scaling.sh.patch');
'perms' = '0644';

# cinder-csi patch
# panlint disable=LP006
prefix '{/usr/lib/python3.9/site-packages/magnum/drivers/common/templates/kubernetes/fragments/enable-cinder-csi.sh.patch}';
'config' = file_contents('features/magnum/magnum-k8s-fixes/enable-cinder-csi.sh.patch');
'perms' = '0644';

# keystone-auth patch
# panlint disable=LP006
prefix '{/usr/lib/python3.9/site-packages/magnum/drivers/common/templates/kubernetes/fragments/enable-keystone-auth.sh.patch}';
'config' = file_contents('features/magnum/magnum-k8s-fixes/enable-keystone-auth.sh.patch');
'perms' = '0644';
