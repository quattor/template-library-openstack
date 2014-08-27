template personality/cinder/volumes/rpms/config;

prefix '/software/packages';

'{openstack-cinder}' ?= nlist();
'{openstack-utils}' ?= nlist();
