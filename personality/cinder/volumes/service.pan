
unique template personality/cinder/volumes/service;

variable CINDER_MYSQL_SERVER ?= OPENSTACK_MYSQL_SERVER;

# Add RPMs for Cinder Volumes
include { 'personality/cinder/volumes/rpms/config' };

# Add Cinder Volumes configuration
include { 'personality/cinder/volumes/config' };

# TODO: Add TGT support
