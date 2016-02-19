unique template features/cinder/storage/lvm;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'lvm2-lvmetad/on' = '';
'lvm2-lvmetad/startstop' = true;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/enabled_backends' = 'lvm';

# [lvm] section
'contents/lvm/volume_driver' = 'cinder.volume.drivers.lvm.LVMVolumeDriver';
'contents/lvm/volume_group' = 'cinder-volumes';
'contents/lvm/isci_protocol' = 'iscsi';
'contents/lvm/iscsi_helper' = 'lioadm';

