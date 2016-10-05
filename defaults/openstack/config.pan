unique template defaults/openstack/config;

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

variable OPENSTACK_HA ?= false;



############################
# Active SSL configuration #
############################
variable OPENSTACK_SSL ?= false;
variable OPENSTACK_SSL_CERT ?= '/etc/certs/' + FULL_HOSTNAME + '.crt';
variable OPENSTACK_SSL_KEY ?= '/etc/certs/' + FULL_HOSTNAME + '.key';
variable OPENSTACK_SSL_CHAIN ?= null;

##############
# RegionName #
##############
variable OPENSTACK_REGION_NAME ?= 'RegionOne';

############################################
# Virtual Machine interface for hypervisor #
############################################
variable OPENSTACK_INTERFACE_MAPPING ?= boot_nic();

# Force user to specify OPENSTACK_ADMIN_TOKEN
variable OPENSTACK_ADMIN_TOKEN ?= error('OPENSTACK_ADMIN_TOKEN must be declared');
variable OPENSTACK_USERNAME ?= 'admin';
variable OPENSTACK_PASSWORD ?= 'admin';
variable OPENSTACK_METADATA_SECRET ?= error('OPENSTACK_METADATA_SECRET must be declared');

##########################################
# NODE_TYPE is 'compute' or 'controller' #
##########################################
variable OPENSTACK_NODE_TYPE ?= 'compute';
variable OPENSTACK_LOGGING_TYPE ?= 'file';
variable OPENSTACK_AUTH_CLIENT_CONFIG ?= 'features/keystone/client/config';

###############################
# Define OPENSTACK_CONTROLLER_HOST  #
##############################
variable OPENSTACK_CONTROLLER_HOST ?= error('OPENSTACK_CONTROLLER_HOST must be declared');
variable OPENSTACK_CONTROLLER_PROTOCOL ?= if (OPENSTACK_SSL) {
  'https';
} else {
  'http';
};

#############################
# Mariadb specific variable #
#############################
variable OPENSTACK_DB_HOST ?= 'localhost';
variable OPENSTACK_DB_ADMIN_USERNAME ?= 'root';
variable OPENSTACK_DB_ADMIN_PASSWORD ?= 'root';

############################
# Glance specific variable #
############################
variable OPENSTACK_GLANCE_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_GLANCE_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_GLANCE_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_GLANCE_DB_USERNAME ?= 'glance';
variable OPENSTACK_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';
variable OPENSTACK_GLANCE_MULTIPLE_LOCATIONS ?= null;
variable OPENSTACK_GLANCE_USERNAME ?= 'glance';
variable OPENSTACK_GLANCE_PASSWORD ?= 'GLANCE_PASS';
variable OPENSTACK_GLANCE_STORE_DIR ?= '/var/lib/glance/images/';
variable OPENSTACK_GLANCE_PORT ?= 9292;

############################
# Heat specific variable #
############################
variable OPENSTACK_HEAT_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_HEAT_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_HEAT_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_HEAT_ENABLED ?= false;
variable OPENSTACK_HEAT_DB_USERNAME ?= 'heat';
variable OPENSTACK_HEAT_DB_PASSWORD ?= 'HEAT_DBPASS';
variable OPENSTACK_HEAT_USERNAME ?= 'heat';
variable OPENSTACK_HEAT_PASSWORD ?= 'HEAT_PASS';
variable OPENSTACK_HEAT_STACK_DOMAIN ?= 'heat';
variable OPENSTACK_HEAT_DOMAIN_ADMIN_USERNAME ?= 'heat_domain_admin';
variable OPENSTACK_HEAT_DOMAIN_ADMIN_PASSWORD ?= 'HEAT_DOMAIN_ADMIN_PASS';
variable OPENSTACK_HEAT_CFN_PORT ?= 8000;
variable OPENSTACK_HEAT_PORT ?= 8004;
variable OPENSTACK_HEAT_PORTS ?= list(OPENSTACK_HEAT_PORT,OPENSTACK_HEAT_CFN_PORT);

##############################
# Keystone specific variable #
##############################
variable OPENSTACK_KEYSTONE_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_KEYSTONE_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_KEYSTONE_DB_USERNAME ?= 'keystone';
variable OPENSTACK_KEYSTONE_DB_PASSWORD ?= 'KEYSTONE_DBPASS';
variable OPENSTACK_KEYSTONE_IDENTITY_DRIVER ?= 'sql';
variable OPENSTACK_KEYSTONE_IDENTITY_LDAP_PARAMS ?= dict();
variable OPENSTACK_KEYSTONE_PORT ?= 5000;
variable OPENSTACK_KEYSTONE_ADMIN_PORT ?= 35357;
variable OPENSTACK_KEYSTONE_PORTS ?= list(OPENSTACK_KEYSTONE_PORT,OPENSTACK_KEYSTONE_ADMIN_PORT);
variable OPENSTACK_KEYSTONE_TOKEN_PROVIDER ?= 'uuid';
variable OPENSTACK_KEYSTONE_TOKEN_DRIVER ?= 'memcache';

#############################
# Memcache specfic variable #
#############################
variable OPENSTACK_MEMCACHE_HOSTS ?= list('localhost');

#############################
# MongoDB specfic variable #
#############################
variable OPENSTACK_MONGODB_VERSION ?= 2;
variable OPENSTACK_MONGODB_DBPATH ?= '/var/mongodb';

##########################
# Nova specific variable #
##########################
variable OPENSTACK_NOVA_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_NOVA_VNC_HOST ?= OPENSTACK_NOVA_CONTROLLER_HOST;
variable OPENSTACK_NOVA_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_NOVA_VNC_PROTOCOL ?= OPENSTACK_NOVA_CONTROLLER_PROTOCOL;
variable OPENSTACK_NOVA_CPU_RATIO ?= 1.0;
variable OPENSTACK_NOVA_RAM_RATIO ?= 1.0;
variable OPENSTACK_NOVA_RESUME_VM_ON_BOOT ?= false;
variable OPENSTACK_NOVA_VIRT_TYPE ?= 'kvm';
variable OPENSTACK_NOVA_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_NOVA_DB_USERNAME ?= 'nova';
variable OPENSTACK_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';
variable OPENSTACK_NOVA_USERNAME ?= 'nova';
variable OPENSTACK_NOVA_PASSWORD ?= 'NOVA_PASS';
variable OPENSTACK_NOVA_OSAPI_PORT ?= 8774;
variable OPENSTACK_NOVA_EC2_PORT ?= 8773;
variable OPENSTACK_NOVA_METADATA_PORT ?= 8774;
variable OPENSTACK_NOVA_NOVNC_PORT ?= 6080;
variable OPENSTACK_NOVA_PORTS ?= list(OPENSTACK_NOVA_OSAPI_PORT, OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_NOVNC_PORT);

#############################
# Neutron specific variable #
#############################
variable OPENSTACK_NEUTRON_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_NEUTRON_NETWORK_PROVIDER ?= OPENSTACK_NEUTRON_CONTROLLER_HOST;
variable OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_NEUTRON_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_NEUTRON_DB_USERNAME ?= 'neutron';
variable OPENSTACK_NEUTRON_DB_PASSWORD ?= 'NEUTRON_DBPASS';
variable OPENSTACK_NEUTRON_USERNAME ?= 'neutron';
variable OPENSTACK_NEUTRON_PASSWORD ?= 'NEUTRON_PASS';
variable OPENSTACK_NEUTRON_MECHANISM ?= 'linuxbridge';
variable OPENSTACK_NEUTRON_NETWORK_TYPE ?= 'provider-service';
variable OPENSTACK_NEUTRON_OVERLAY_IP ?= PRIMARY_IP;
variable OPENSTACK_NEUTRON_BASE_MAC ?= null;
variable OPENSTACK_NEUTRON_DVR_BASE_MAC ?= null;
variable OPENSTACK_NEUTRON_PORT ?= 9696;
variable OPENSTACK_NEUTRON_METADATA_PORT ?= 9697;
variable OPENSTACK_NEUTRON_DEFAULT ?= true;
variable OPENSTACK_NEUTRON_DEFAULT_NETWORKS ?= "192.168.0.0/24";
variable OPENSTACK_NEUTRON_DEFAULT_DHCP_POOL ?= dict(
  'start', '192.168.0.10',
  'end', '192.168.0.254',
);
variable OPENSTACK_NEUTRON_DEFAULT_GATEWAY ?= '192.168.0.1';
variable OPENSTACK_NEUTRON_DEFAULT_NAMESERVER ?= '192.168.0.1';


############################
# Cinder specific variable #
############################

# Cinder Controller
variable OPENSTACK_CINDER_ENABLED ?= false;
variable OPENSTACK_CINDER_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_CINDER_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_CINDER_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_CINDER_DB_USERNAME ?= 'cinder';
variable OPENSTACK_CINDER_DB_PASSWORD ?= 'CINDER_DBPASS';
variable OPENSTACK_CINDER_USERNAME ?= 'cinder';
variable OPENSTACK_CINDER_PASSWORD ?= 'CINDER_PASS';
# Cinder Storage
variable OPENSTACK_CINDER_STORAGE_HOST ?= OPENSTACK_CINDER_CONTROLLER_HOST;
variable OPENSTACK_CINDER_STORAGE_TYPE ?= 'lvm';
variable OPENSTACK_CINDER_PORT ?= 8776;

############################
# Ceilometer specific variable #
############################
variable OPENSTACK_CEILOMETER_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_CEILOMETER_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
variable OPENSTACK_CEILOMETER_METERS_ENABLED ?= false;
variable OPENSTACK_CEILOMETER_DB_HOST ?= OPENSTACK_DB_HOST;
variable OPENSTACK_CEILOMETER_ENABLED ?= false;
variable OPENSTACK_CEILOMETER_DB_USERNAME ?= 'ceilometer';
variable OPENSTACK_CEILOMETER_DB_PASSWORD ?= 'CEILOMETER_DBPASS';
variable OPENSTACK_CEILOMETER_USERNAME ?= 'ceilometer';
variable OPENSTACK_CEILOMETER_PASSWORD ?= 'CEILOMETER_PASS';
variable OPENSTACK_CEILOMETER_PORT ?= 8777;

##############################
# RabbitMQ specific variable #
##############################
variable OPENSTACK_RABBITMQ_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_RABBITMQ_USERNAME ?= 'openstack';
variable OPENSTACK_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';

###########
# Horizon #
###########
variable OPENSTACK_HORIZON_HOST ?= OPENSTACK_CONTROLLER_HOST;
variable OPENSTACK_HORIZON_PORT ?= {
  if (OPENSTACK_SSL) {
    port = 443;
  } else {
    port = 80
  };
};
variable OPENSTACK_HORIZON_ALLOWED_HOSTS ?= list('*');
variable OPENSTACK_HORIZON_DEFAULT_ROLE ?= 'user';
variable OPENSTACK_HORIZON_SECRET_KEY ?= error('OPENSTACK_HORIZON_SECRET_KEY must be defined');
variable OPENSTACK_HORIZON_DEFAULT_DOMAIN ?= 'default';
variable OPENSTACK_HORIZON_KEYSTONE_API_VERSION ?= '3';
variable OPENSTACK_HORIZON_MULTIDOMAIN_ENABLED ?= {
  if (OPENSTACK_KEYSTONE_IDENTITY_DRIVER == 'sql') {
    false;
  } else {
    true;
  };
};


##############################
# Metadata specific variable #
##############################
variable OPENSTACK_METADATA_HOST ?= OPENSTACK_NOVA_CONTROLLER_HOST;

###########################
# CEPH Specific Variables #
###########################
variable OPENSTACK_CEPH ?= false;
variable OPENSTACK_CEPH_NOVA ?= OPENSTACK_CEPH;
variable OPENSTACK_CEPH_GLANCE ?= OPENSTACK_CEPH;
variable OPENSTACK_CEPH_GLANCE_POOL ?= 'images';
variable OPENSTACK_CEPH_GLANCE_USER ?= 'glance';
variable OPENSTACK_CEPH_GLANCE_CEPH_CONF ?= '/etc/ceph/ceph.conf';
variable OPENSTACK_CEPH_CINDER_POOL ?= 'volumes';
variable OPENSTACK_CEPH_CINDER_USER ?= 'cinder';
variable OPENSTACK_CEPH_CINDER_CEPH_CONF ?= '/etc/ceph/ceph.conf';
variable OPENSTACK_CEPH_CINDER_BACKUP_POOL ?= 'backups';
variable OPENSTACK_CEPH_CINDER_BACKUP_USER ?= 'cinder-backup';
variable OPENSTACK_CEPH_CINDER_BACKUP_CEPH_CONF ?= '/etc/ceph/ceph.conf';
variable OPENSTACK_CEPH_NOVA_POOL ?= 'vms';
variable OPENSTACK_CEPH_NOVA_USER ?= 'cinder';
variable OPENSTACK_CEPH_NOVA_CEPH_CONF ?= '/etc/ceph/ceph.conf';
variable OPENSTACK_CEPH_LIBVIRT_SECRET ?= {
  if (OPENSTACK_CEPH) {
    error('OPENSTACK_CEPH_LIBVIRT_SECRET must be defined when OPENSTACK_CEPH is true');
  } else {
    null;
  };
};

########################################
# SNMPD configuration (for ceilometer) #
########################################
variable OPENSTACK_SNMPD_COMMUNITY ?= 'openstack';
variable OPENSTACK_SNMPD_LOCATION ?= 'undef';
variable OPENSTACK_SNMPD_CONTACT ?= 'root <root@localhost>';
variable OPENSTACK_SNMPD_IP ?= PRIMARY_IP;

include if (OPENSTACK_HA) {'defaults/openstack/ha';} else {null;};
