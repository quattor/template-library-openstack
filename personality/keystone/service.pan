
unique template personality/keystone/service;

variable KEYSTONE_MYSQL_SERVER ?= FULL_HOSTNAME;

# Add RPMs for Keystone
include { 'personality/keystone/rpms/config' };

# Add Keystone server configuration
include { 'personality/keystone/config' };

# Configure MySQL server
variable MYSQL_INCLUDE = {
  if (KEYSTONE_MYSQL_SERVER == FULL_HOSTNAME) {
    'features/mysql/server';
  } else {
    'null';
  }
};
include { MYSQL_INCLUDE };
