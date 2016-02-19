unique template features/nova/controller/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-nova-api}' ?= dict();
'{openstack-nova-cert}' ?= dict();
'{openstack-nova-conductor}' ?= dict();
'{openstack-nova-console}' ?= dict();
'{openstack-nova-novncproxy}' ?= dict();
'{openstack-nova-scheduler}' ?= dict();
'{python-novaclient}' ?= dict();
