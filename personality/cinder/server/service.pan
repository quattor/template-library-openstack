
unique template personality/cinder/server/service;

variable CINDER_MYSQL_SERVER ?= OPENSTACK_MYSQL_SERVER;

# Add RPMs for Cinder
include { 'personality/cinder/server/rpms/config' };

# Add Cinder server configuration
include { 'personality/cinder/server/config' };

# Configure MySQL server
variable MYSQL_INCLUDE = {
  if (CINDER_MYSQL_SERVER == FULL_HOSTNAME) {
    'features/mysql/server';
  } else {
    null;
  }
};
include { MYSQL_INCLUDE };
