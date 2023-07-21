unique template machine-types/cloud/base;

variable OPENSTACK_CORE_MACHINE_TYPE ?= 'machine-types/core';
include OPENSTACK_CORE_MACHINE_TYPE;

# Fix list of Openstack user that should not be deleted
include 'features/openstack/accounts';

# Include some useful RPMs
include 'features/openstack/rpms';
