unique template features/glance/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'python-glanceclient' ?= dict();
'python-glance' ?= dict();
'openstack-glance' ?= dict();
