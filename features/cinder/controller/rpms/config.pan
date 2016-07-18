unique template features/cinder/controller/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-cinder}' ?= dict();
'{python-cinderclient}' ?= dict();
# TODO: Probably must be on cloud/base machine
'{python-oslo-policy}' ?= dict();
