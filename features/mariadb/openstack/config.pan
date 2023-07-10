unique template features/mariadb/openstack/config;

include 'features/mariadb/openstack/rpms/config';

include 'defaults/openstack/config';

# MariaDB : enable and increase file limit
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'mariadb/startstop' = true;
'mariadb/file/replace' = false;
'mariadb/file/config/unit/After' = list('fs.target');
'mariadb/file/config/service/LimitNOFILE' = 50000;

# Customize server configuration
include 'components/metaconfig/config';
include 'features/mariadb/openstack/schema';
prefix '/software/components/metaconfig/services/{/etc/my.cnf.d/quattor-openstack.cnf}';
'module' = 'tiny';
'convert/joincomma' = true;
'daemons/mariadb' = 'restart';
bind '/software/components/metaconfig/services/{/etc/my.cnf.d/quattor-openstack.cnf}/contents' = openstack_mariadb_config;
'contents/mysqld/max_connections' = 50000;


# Configure databases
include 'components/mysql/config';
prefix '/software/components/mysql';
'servers' = {
  # Keystone server configuration
  SELF[OS_KEYSTONE_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_KEYSTONE_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;

  # Glance server configuration
  SELF[OS_GLANCE_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_GLANCE_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;

  # Nova server configuration
  SELF[OS_NOVA_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_NOVA_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;

  # Neutron server configuration
  SELF[OS_NEUTRON_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_NEUTRON_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;
  SELF;

  # Cinder server configuration
  SELF[OS_CINDER_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_CINDER_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;
  SELF;

  # Heat server configuration
  SELF[OS_HEAT_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_HEAT_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;
  SELF;
};
'serviceName' = 'mariadb';

# Configure each database
include 'features/mariadb/openstack/keystone';
include 'features/mariadb/openstack/glance';
include 'features/mariadb/openstack/neutron';
include 'features/mariadb/openstack/nova';
include if (OS_CINDER_ENABLED) 'features/mariadb/openstack/cinder';
include if (OS_HEAT_ENABLED) 'features/mariadb/openstack/heat';
