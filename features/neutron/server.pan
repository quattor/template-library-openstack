# Configuration common to the controller and network provider server

unique template features/neutron/server;

# Include Neutron base configuration
include 'features/neutron/base';

# Neutron plugin
include 'features/neutron/plugins/ml2_conf';

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'contents/DEFAULT/allow_overlapping_ips' = true;
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/dns_domain' = OS_NEUTRON_DNS_DOMAIN;
'contents/DEFAULT/service_plugins' = list('router');

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'neutron-server/startstop' = true;

