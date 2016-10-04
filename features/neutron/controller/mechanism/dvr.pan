template features/neutron/controller/mechanism/dvr;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT/router_distributed' = 'True';
'contents/DEFAULT/dvr_base_mac' = OPENSTACK_NEUTRON_DVR_BASE_MAC;
