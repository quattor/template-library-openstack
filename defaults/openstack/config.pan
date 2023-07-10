unique template defaults/openstack/config;

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

############################
# Active SSL configuration #
############################
variable OS_SSL ?= false;
variable OS_SSL_CERT ?= '/etc/certs/' + FULL_HOSTNAME + '.crt';
variable OS_SSL_KEY ?= '/etc/certs/' + FULL_HOSTNAME + '.key';

#####################
# Region parameters #
#####################
variable OS_REGION_NAME ?= 'RegionOne';
variable OS_CLOUD_TIMEZONE ?= error("You must specify your cloud timezone with OS_CLOUD_TIMEZONE");

############################################
# Virtual Machine interface for hypervisor #
############################################
variable OS_INTERFACE_MAPPING ?= boot_nic();

# Force user to specify OS_ADMIN_TOKEN
variable OS_ADMIN_TOKEN ?= error('OS_ADMIN_TOKEN must be declared');
variable OS_USERNAME ?= 'admin';
variable OS_PASSWORD ?= 'admin';
variable OS_METADATA_SECRET ?= error('OS_METADATA_SECRET must be declared');

variable OS_LOGGING_TYPE ?= 'file';
variable OS_AUTH_CLIENT_CONFIG ?= 'features/keystone/client/config';

###############################
# Define OS_CONTROLLER_HOST  #
##############################
variable OS_CONTROLLER_HOST ?= error('OS_CONTROLLER_HOST must be declared');
variable OS_CONTROLLER_PROTOCOL ?= if (OS_SSL) {
  'https';
} else {
  'http';
};

#############################
# Mariadb specific variable #
#############################
variable OS_DB_HOST ?= 'localhost';
variable OS_DB_ADMIN_USERNAME ?= 'root';
variable OS_DB_ADMIN_PASSWORD ?= 'root';

###############################
# EC2 Auth specific variables #
###############################
variable OS_EC2_AUTH_ENABLED ?= false;

############################
# Glance specific variable #
############################
variable OS_GLANCE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_GLANCE_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_GLANCE_PUBLIC_HOST ?= OS_GLANCE_CONTROLLER_HOST;
variable OS_GLANCE_CONTROLLER_PORT ?= if ( OS_GLANCE_CONTROLLER_PROTOCOL == 'https' ) 9293 else 9292;
variable OS_GLANCE_PUBLIC_PORT ?= if ( OS_GLANCE_CONTROLLER_PROTOCOL == 'https' ) 9292 else null;
variable OS_GLANCE_DB_HOST ?= OS_DB_HOST;
variable OS_GLANCE_DB_USERNAME ?= 'glance';
variable OS_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';
variable OS_GLANCE_MULTIPLE_LOCATIONS ?= null;
variable OS_GLANCE_USERNAME ?= 'glance';
variable OS_GLANCE_PASSWORD ?= 'GLANCE_PASS';

##########################
# Heat specific variable #
##########################
variable OS_HEAT_HOST ?= OS_CONTROLLER_HOST;
variable OS_HEAT_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_HEAT_DB_HOST ?= OS_DB_HOST;
variable OS_HEAT_ENABLED ?= false;
variable OS_HEAT_DB_USERNAME ?= 'heat';
variable OS_HEAT_DB_PASSWORD ?= 'HEAT_DBPASS';
variable OS_HEAT_USERNAME ?= 'heat';
variable OS_HEAT_PASSWORD ?= 'HEAT_PASS';
variable OS_HEAT_STACK_DOMAIN ?= 'heat';
variable OS_HEAT_USER_DOMAIN ?= 'default';
variable OS_HEAT_DOMAIN_ADMIN_USERNAME ?= 'heat_domain_admin';
variable OS_HEAT_DOMAIN_ADMIN_PASSWORD ?= 'HEAT_DOMAIN_ADMIN_PASS';

######################
# Barbican variables #
######################
variable OS_BARBICAN_HOST ?= OS_CONTROLLER_HOST;
variable OS_BARBICAN_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_BARBICAN_PORT ?= 9311;
variable OS_BARBICAN_USERNAME ?= 'barbican';
variable OS_BARBICAN_PASSWORD ?= 'BARBICAN_PASS';
variable OS_BARBICAN_DB_USERNAME ?= 'barbican_user';
variable OS_BARBICAN_DB_PASSWORD ?= 'BARBICAN_REAL_PASS';
variable OS_BARBICAN_DB_HOST ?= OS_DB_HOST;

###################
# Magnum variales #
###################
variable OS_MAGNUM_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_MAGNUM_HOST ?= OS_CONTROLLER_HOST;
variable OS_MAGNUM_PORT ?= 9511;
variable OS_MAGNUM_DEFAULT_VOLUME_TYPE ?= 'magnum_volume_type';
variable OS_REGION_NAME ?= 'default';
variable OS_MAGNUM_DB_USERNAME ?= 'DB USER TO SET';
variable OS_MAGNUM_DB_PASSWORD ?= 'DB_MAGNUM_DBPASS';
variable OS_MAGNUM_DB_HOST ?= OS_DB_HOST;
variable OS_MAGNUM_ADMIN_USERNAME ?= 'magnum';
variable OS_MAGNUM_ADMIN_PASSWORD ?= 'MAGNUM_ADMNINPASS';
variable OS_MAGNUM_ADMIN_TENANT_NAME ?= 'service';
variable OS_MAGNUM_DOMAIN_ADMIN_USERNAME ?= 'magnum_domain_admin_user';
variable OS_MAGNUM_DOMAIN_ADMIN_PASSWORD ?= 'MAGNUM_DOMAIN_ADMIN_USER_PASS';
variable OS_MAGNUM_CLUSTER_USER_TRUST ?= true;
variable OS_MAGNUM_RPC_CONN_POOL_SIZE ?= 200;

##############################
# Keystone specific variable #
##############################
variable OS_KEYSTONE_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_KEYSTONE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_KEYSTONE_CONTROLLER_TOKEN_PORT ?= '35357';
variable OS_KEYSTONE_PUBLIC_CONTROLLER_HOST ?= OS_KEYSTONE_CONTROLLER_HOST;
variable OS_KEYSTONE_PUBLIC_CONTROLLER_TOKEN_PORT ?= '5000';
variable OS_KEYSTONE_DB_HOST ?= OS_DB_HOST;
variable OS_KEYSTONE_DB_USERNAME ?= 'keystone';
variable OS_KEYSTONE_DB_PASSWORD ?= 'KEYSTONE_DBPASS';
variable OS_KEYSTONE_IDENTITY_DRIVER ?= 'sql';
variable OS_KEYSTONE_IDENTITY_LDAP_PARAMS ?= dict();
variable OS_KEYSTONE_TOKEN_AUTH_TYPE ?= 'password';

#############################
# Trustee specific variable #
#############################
variable OS_TRUSTEE_TOKEN_AUTH_TYPE ?= OS_KEYSTONE_TOKEN_AUTH_TYPE;

#############################
# Memcache specfic variable #
#############################
variable OS_MEMCACHE_HOST ?= 'localhost';

##########################
# Nova specific variable #
##########################
variable OS_NOVA_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NOVA_VNC_HOST ?= OS_NOVA_CONTROLLER_HOST;
variable OS_NOVA_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_NOVA_VNC_PROTOCOL ?= OS_NOVA_CONTROLLER_PROTOCOL;
variable OS_NOVA_OVERWRITE_DEFAULT_POLICY ?= false;
variable OS_NOVA_RESUME_VM_ON_BOOT ?= false;
variable OS_NOVA_CPU_RATIO ?= 1.0;
variable OS_NOVA_CPU_WEIGHT_MULTIPLIER ?= 1.0;
variable OS_NOVA_DISK_WEIGHT_MULTIPLIER ?= 1.0;
variable OS_NOVA_RAM_RATIO ?= 1.0;
variable OS_NOVA_RAM_WEIGHT_MULTIPLIER ?= 1.0;
variable OS_NOVA_VIRT_TYPE ?= 'kvm';
variable OS_NOVA_DB_HOST ?= OS_DB_HOST;
variable OS_NOVA_DB_USERNAME ?= 'nova';
variable OS_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';
variable OS_NOVA_USERNAME ?= 'nova';
variable OS_NOVA_PASSWORD ?= 'NOVA_PASS';
variable OS_NOVA_METADATA_HOST ?= OS_NOVA_CONTROLLER_HOST;
variable OS_NOVA_UPGRADE_LEVELS ?= error('OS_NOVA_UPGRADE_LEVELS must be defined to the appropriate value for the current OpenStack cluster');
# Ceph-related Variables
variable OS_NOVA_USE_CEPH ?= true;
variable OS_NOVA_CEPH_POOL ?= 'vms';
variable OS_NOVA_CEPH_USER ?= 'cinder';
variable OS_NOVA_CEPH_CEPH_CONF ?= '/etc/ceph/ceph.conf';


#############################
# Neutron specific variable #
#############################
variable OS_NEUTRON_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NEUTRON_NETWORK_PROVIDER ?= OS_NEUTRON_CONTROLLER_HOST;
variable OS_NEUTRON_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_NEUTRON_DB_HOST ?= OS_DB_HOST;
variable OS_NEUTRON_DB_USERNAME ?= 'neutron';
variable OS_NEUTRON_DB_PASSWORD ?= 'NEUTRON_DBPASS';
variable OS_NEUTRON_USERNAME ?= 'neutron';
variable OS_NEUTRON_PASSWORD ?= 'NEUTRON_PASS';
variable OS_NEUTRON_NETWORK_TYPE ?= 'provider-service';
variable OS_NEUTRON_OVERLAY_IP ?= PRIMARY_IP;
variable OS_NEUTRON_BASE_MAC ?= null;
variable OS_NEUTRON_DVR_BASE_MAC ?= null;
variable OS_NEUTRON_DEFAULT ?= true;
variable OS_NEUTRON_DEFAULT_NETWORKS ?= "192.168.0.0/24";
variable OS_NEUTRON_DEFAULT_DHCP_POOL ?= dict(
  'start', '192.168.0.10',
  'end', '192.168.0.254',
);
variable OS_NEUTRON_DEFAULT_GATEWAY ?= '192.168.0.1';
variable OS_NEUTRON_DEFAULT_NAMESERVER ?= '192.168.0.1';
variable OS_NEUTRON_DNS_DOMAIN ?= 'openstacklocal';
variable OS_NEUTRON_VLAN_RANGES ?= undef;
variable OS_NEUTRON_DB_POOL_SIZE ?= 100;
variable OS_NEUTRON_DB_MAX_OVERFLOW ?= 200;
variable OS_NEUTRON_DHCP_LEASE_DURATION ?= 86400;

############################
# Placement specific variable #
############################
variable OS_PLACEMENT_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_PLACEMENT_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_PLACEMENT_CONTROLLER_PORT ?= 8778;
variable OS_PLACEMENT_DB_HOST ?= OS_DB_HOST;
variable OS_PLACEMENT_DB_USERNAME ?= 'placement';
variable OS_PLACEMENT_DB_PASSWORD ?= 'PLACEMENT_DBPASS';
variable OS_PLACEMENT_USERNAME ?= 'placement';
variable OS_PLACEMENT_PASSWORD ?= 'PLACEMENT_PASS';

############################
# Cinder specific variable #
############################

# Cinder Controller
variable OS_CINDER_ENABLED ?= false;
variable OS_CINDER_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_CINDER_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_CINDER_PUBLIC_HOST ?= OS_CINDER_CONTROLLER_HOST;
variable OS_CINDER_CONTROLLER_PORT ?= if ( OS_CINDER_CONTROLLER_PROTOCOL == 'https' ) 8777 else 8776;
variable OS_CINDER_PUBLIC_PORT ?= if ( OS_CINDER_CONTROLLER_PROTOCOL == 'https' ) 8776 else null;
variable OS_CINDER_DB_HOST ?= OS_DB_HOST;
variable OS_CINDER_DB_USERNAME ?= 'cinder';
variable OS_CINDER_DB_PASSWORD ?= 'CINDER_DBPASS';
variable OS_CINDER_USERNAME ?= 'cinder';
variable OS_CINDER_PASSWORD ?= 'CINDER_PASS';
# Cinder Backup
variable OS_CINDER_BACKUP_ENABLED ?= false;
variable OS_CINDER_BACKUP_CEPH_POOL ?= 'backup';
variable OS_CINDER_BACKUP_CEPH_USER ?= 'cinder-backup';
variable OS_CINDER_BACKUP_CEPH_CONF ?= '/etc/ceph/ceph.conf';

############################
# Ceilometer specific variable #
############################
variable OS_CEILOMETER_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_CEILOMETER_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_CEILOMETER_METERS_ENABLED ?= false;
variable OS_CEILOMETER_DB_HOST ?= OS_DB_HOST;
variable OS_CEILOMETER_ENABLED ?= false;
variable OS_CEILOMETER_DB_USERNAME ?= 'ceilometer';
variable OS_CEILOMETER_DB_PASSWORD ?= 'CEILOMETER_DBPASS';
variable OS_CEILOMETER_USERNAME ?= 'ceilometer';
variable OS_CEILOMETER_PASSWORD ?= 'CEILOMETER_PASS';



##############################
# RabbitMQ specific variable #
##############################
variable OS_RABBITMQ_HOST ?= OS_CONTROLLER_HOST;
variable OS_RABBITMQ_USERNAME ?= 'openstack';
variable OS_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';

###########
# Horizon #
###########
variable OS_HORIZON_HOST ?= FULL_HOSTNAME;
variable OS_HORIZON_PROTOCOL ?= 'https';
variable OS_HORIZON_ALLOWED_HOSTS ?= list(OS_HORIZON_HOST);
variable OS_HORIZON_CONFIGURE_LOCAL_SETTINGS ?= true;
variable OS_HORIZON_DEFAULT_ROLE ?= 'users';
variable OS_HORIZON_SECRET_KEY ?= error('OS_HORIZON_SECRET_KEY must be defined');
variable OS_HORIZON_DEFAULT_DOMAIN ?= 'default';
variable OS_HORIZON_ROOT_URL ?= '/dashboard';
variable OS_HORIZON_KEYSTONE_API_VERSION ?= 3;
variable OS_HORIZON_MULTIDOMAIN_ENABLED ?= if (OS_KEYSTONE_IDENTITY_DRIVER == 'sql') {
    false;
} else {
    true;
};

########################################
# SNMPD configuration (for ceilometer) #
########################################
variable OS_SNMPD_COMMUNITY ?= 'openstack';
variable OS_SNMPD_LOCATION ?= 'undef';
variable OS_SNMPD_CONTACT ?= 'root <root@localhost>';
variable OS_SNMPD_IP ?= PRIMARY_IP;
