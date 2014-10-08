
unique template personality/nova/controller/service;

variable NOVA_MYSQL_SERVER ?= MYSQL_HOST;

# Add RPMs for Nova
include { 'personality/nova/controller/rpms/config' };

# Add Nova controller configuration
include { 'personality/nova/controller/config' };

# Configure MySQL server
variable MYSQL_INCLUDE = {
  if (NOVA_MYSQL_SERVER == FULL_HOSTNAME) {
    'features/mysql/server';
  } else {
    null;
  }
};
include { MYSQL_INCLUDE };
