unique template features/heat/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'python-heatclient' ?= dict();
'openstack-heat-engine' ?= dict();
'openstack-heat-api' ?= dict();
'openstack-heat-api-cfn' ?= dict();
