
unique template personality/glance/service;

variable GLANCE_MYSQL_SERVER ?= OPENSTACK_MYSQL_SERVER;

# Add RPMs for Glance
include { 'personality/glance/rpms/config' };

# Add Cinder server configuration
include { 'personality/glance/config' };

# Configure MySQL server
variable MYSQL_INCLUDE = {
  if (GLANCE_MYSQL_SERVER == FULL_HOSTNAME) {
    'features/mysql/server';
  } else {
    null;
  }
};
include { MYSQL_INCLUDE };
