unique template features/neutron/network/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-neutron}' ?= dict();
'{openstack-neutron-linuxbridge}' ?= dict();
'{openstack-neutron-ml2}' ?= dict();
'{python-neutronclient}' ?= dict();
'{ebtables}' ?= dict();
'{ipset}' ?= dict();
