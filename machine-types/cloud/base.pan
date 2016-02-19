unique template machine-types/cloud/base;

include 'machine-types/core';
# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include some useful RPMs
include 'defaults/openstack/rpms';
