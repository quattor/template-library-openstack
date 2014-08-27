unique template personality/cinder/volumes/config;

variable CINDER_SERVICES ?= list('openstack-cinder-volumes');

# include configuration common to all Cinder components
include { 'personality/cinder/config' };
