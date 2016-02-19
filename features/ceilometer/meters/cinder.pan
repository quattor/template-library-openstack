unique template features/ceilometer/meters/cinder;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';
'daemons/openstack-cinder-api' = 'restart';
'daemons/openstack-cinder-scheduler' = 'restart';

# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'messagingv2';
