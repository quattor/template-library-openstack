unique template features/nova/compute/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-nova-compute}' ?= dict();
'{sysfsutils}' ?= dict();
