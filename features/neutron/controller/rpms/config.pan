unique template features/neutron/controller/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-neutron}' ?= dict();
'{openstack-neutron-ml2}' ?= dict();
'{python-neutronclient}' ?= dict();
