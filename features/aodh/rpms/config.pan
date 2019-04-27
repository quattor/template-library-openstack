unique template features/aodh/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'python-aodhclient' ?= dict();
'openstack-aodh-evaluator' ?= dict();
'openstack-aodh-api' ?= dict();
'openstack-aodh-notifier' ?= dict();
'openstack-aodh-expirer' ?= dict();
'openstack-aodh-listener' ?= dict();
