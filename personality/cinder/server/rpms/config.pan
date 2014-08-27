template personality/cinder/server/rpms/config;

prefix '/software/packages';

'{openstack-cinder}' ?= nlist();
'{openstack-utils}' ?= nlist();
'{openstack-selinux}' ?= nlist();
