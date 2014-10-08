template personality/nova/controller/rpms/config;

prefix '/software/packages';

'{openstack-nova}' ?= nlist();
'{python-novaclient}' ?= nlist();
