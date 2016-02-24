unique template features/keystone/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'openstack-keystone' ?= dict();
'python-keystoneclient' ?= dict();
