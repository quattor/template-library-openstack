template defaults/openstack/rpms;

prefix '/software/packages';

# Some usefull RPMs that should be automaticaly added
'{openstack-selinux}' ?= dict();
'{openstack-packstack}' ?= dict();
'{python-openstackclient}' ?= dict();
