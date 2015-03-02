# This template defines OpenStack major version and default update.
# Included very early in the configuration.

unique template defaults/openstack/version;

# OpenStack major version (used mainly to tune OS configuration).
# There is no reason to redefine this variable.
variable OPENSTACK_MIDDLEWARE_NAME = 'ICEHOUSE';
variable OPENSTACK_MIDDLEWARE_VERSION = '9';

