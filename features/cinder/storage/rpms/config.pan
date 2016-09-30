unique template features/cinder/storage/rpms/config;

# Install type based RPMs
include 'features/cinder/storage/rpms/' + OPENSTACK_CINDER_STORAGE_TYPE;

prefix '/software/packages';
'{openstack-cinder}' ?= dict();
'{targetcli}' ?= dict();
'{python-oslo-policy}' ?= dict();