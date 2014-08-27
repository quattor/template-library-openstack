template personality/keystone/rpms/config;

prefix '/software/packages';

'{openstack-keystone}' ?= nlist();
'{python-keystoneclient}' ?= nlist();
