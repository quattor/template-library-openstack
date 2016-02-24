unique template features/cinder/controller/rpms/config;

prefix '/software/packages';
'{openstack-cinder}' ?= dict();
'{python-cinderclient}' ?= dict();
# TODO: Probably must be on cloud/base machine
'{python-oslo-policy}' ?= dict();