unique template features/dashboard/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-dashboard}' ?= dict();
