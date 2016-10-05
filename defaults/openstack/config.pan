unique template defaults/openstack/config;

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');
@use{
  type =
  default =
  note = This is the primary IP address of the Host
}
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

@use{
  type = boolean
  default = false
  note = Set this to enable each OpenStack service to be run on multiple hosts.
}
final variable OPENSTACK_HA ?= false;

############################
# Active SSL configuration #
############################
@use{
  type = boolean
  default = false
  note = Set this to true to enable SSL on various services
}
final variable OPENSTACK_SSL ?= false;
@use{
  type = string
  default = '/etc/certs/{FULL_HOSTNAME}.crt'
  note = This is the path of the SSL Cert
}
final variable OPENSTACK_SSL_CERT ?= '/etc/certs/' + FULL_HOSTNAME + '.crt';
@use{
  type = string
  default = '/etc/certs/{FULL_HOSTNAME}.crt'
  note = This is the path of the SSL Key
}
final variable OPENSTACK_SSL_KEY ?= '/etc/certs/' + FULL_HOSTNAME + '.key';
@use{
  type = string
  default = null
  note = This is the path of the SSL Chain, if required
}
final variable OPENSTACK_SSL_CHAIN ?= null;

##############
# RegionName #
##############
@use{
  type = string
  default = RegionOne
  note = The Region to be used by OpenStack
}
final variable OPENSTACK_REGION_NAME ?= 'RegionOne';

############################################
# Virtual Machine interface for hypervisor #
############################################
@use{
  type = string
  default = boot_nic()
  note = The interface that openstack will be bound to.
}
final variable OPENSTACK_INTERFACE_MAPPING ?= boot_nic();

# Force user to specify OPENSTACK_ADMIN_TOKEN
@use{
  type = string
  note = The admin token used for initial setup, will error if not set.
}
final variable OPENSTACK_ADMIN_TOKEN ?= error('OPENSTACK_ADMIN_TOKEN must be declared');
@use{
  type = string
  default = admin
  note = The OpenStack Admin user.
}
final variable OPENSTACK_USERNAME ?= 'admin';
@use{
  type = string
  default = admin
  note = The OpenStack Admin user's password.
}
final variable OPENSTACK_PASSWORD ?= 'admin';
@use{
  type = string
  note =
}
final variable OPENSTACK_METADATA_SECRET ?= error('OPENSTACK_METADATA_SECRET must be declared');

##########################################
# NODE_TYPE is 'compute' or 'controller' #
##########################################
@use{
  type = string
  default = compute
  note = Sets whether a host is a compute node, network node or controller node
}
final variable OPENSTACK_NODE_TYPE ?= 'compute';
@use{
  type = string
  default = file
  note = The type of logging used by OpenStack
}
final variable OPENSTACK_LOGGING_TYPE ?= 'file';
@use{
  type = string
  default =
  note = The file to use for the Keystone Client Authentication schema
}
final variable OPENSTACK_AUTH_CLIENT_CONFIG ?= 'features/keystone/client/config';

###############################
# Define OPENSTACK_CONTROLLER_HOST  #
##############################
@use{
  type = string
  default =
  note = The host to be used as the controller, will generate an error if not set. This is expected to be the DNS for the load balancer in HA environments
}
final variable OPENSTACK_CONTROLLER_HOST ?= error('OPENSTACK_CONTROLLER_HOST must be declared');
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
final variable OPENSTACK_CONTROLLER_PROTOCOL ?= if (OPENSTACK_SSL) {
  'https';
} else {
  'http';
};

#############################
# Mariadb specific variable #
#############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_DB_HOST ?= 'localhost';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_DB_ADMIN_USERNAME ?= 'root';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_DB_ADMIN_PASSWORD ?= 'root';

############################
# Glance specific variable #
############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = glance
  note = Username for Glance to use to connect to it's database
}
final variable OPENSTACK_GLANCE_DB_USERNAME ?= 'glance';
@use{
  type = string
  default = GLANCE_DBPASS
  note = Password for Glance to use to connect to it's database
}
final variable OPENSTACK_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_GLANCE_DB_HOST,
    'dbname' , 'glance',
    'dbuser' , OPENSTACK_GLANCE_DB_USERNAME,
    'dbpassword' , OPENSTACK_GLANCE_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_MULTIPLE_LOCATIONS ?= null;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_USERNAME ?= 'glance';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_PASSWORD ?= 'GLANCE_PASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_STORE_DIR ?= '/var/lib/glance/images/';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_GLANCE_PORT ?= 9292;

############################
# Heat specific variable #
############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_DB_HOST ?= OPENSTACK_DB_HOST;@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_HEAT_DB_HOST,
    'dbname' , 'heat',
    'dbuser' , OPENSTACK_HEAT_DB_USERNAME,
    'dbpassword' , OPENSTACK_HEAT_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
@use{
  type = boolean
  default = false
  note = Whether to enable the Heat component.
}
final variable OPENSTACK_HEAT_ENABLED ?= false;
@use{
  type = string
  default = heat
  note = Username for Heat to use to connect to it's database
}
final variable OPENSTACK_HEAT_DB_USERNAME ?= 'heat';
@use{
  type = string
  default = HEAT_DBPASS
  note = Password for Heat to use to connect to it's database
}
final variable OPENSTACK_HEAT_DB_PASSWORD ?= 'HEAT_DBPASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_USERNAME ?= 'heat';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_PASSWORD ?= 'HEAT_PASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_STACK_DOMAIN ?= 'heat';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_DOMAIN_ADMIN_USERNAME ?= 'heat_domain_admin';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_DOMAIN_ADMIN_PASSWORD ?= 'HEAT_DOMAIN_ADMIN_PASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_CFN_PORT ?= 8000;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_PORT ?= 8004;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HEAT_PORTS ?= list(OPENSTACK_HEAT_PORT,OPENSTACK_HEAT_CFN_PORT);

##############################
# Keystone specific variable #
##############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = keystone
  note = Username for Keystone to use to connect to it's database
}
final variable OPENSTACK_KEYSTONE_DB_USERNAME ?= 'keystone';
@use{
  type = string
  default = KEYSTONE_DBPASS
  note = Password for Keystone to use to connect to it's database
}
final variable OPENSTACK_KEYSTONE_DB_PASSWORD ?= 'KEYSTONE_DBPASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_KEYSTONE_DB_HOST,
    'dbname' , 'keystone',
    'dbuser' , OPENSTACK_KEYSTONE_DB_USERNAME,
    'dbpassword' , OPENSTACK_KEYSTONE_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_IDENTITY_DRIVER ?= 'sql';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_IDENTITY_LDAP_PARAMS ?= dict();
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_PORT ?= 5000;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_ADMIN_PORT ?= 35357;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_PORTS ?= list(OPENSTACK_KEYSTONE_PORT,OPENSTACK_KEYSTONE_ADMIN_PORT);
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_TOKEN_PROVIDER ?= 'uuid';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEYSTONE_TOKEN_DRIVER ?= 'memcache';

#############################
# Memcache specfic variable #
#############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_MEMCACHE_HOST ?= dict('localhost','11211');

#############################
# MongoDB specfic variable #
#############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_MONGODB_VERSION ?= 2;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_MONGODB_DBPATH ?= '/var/mongodb';

##########################
# Nova specific variable #
##########################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_VNC_HOST ?= OPENSTACK_NOVA_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_VNC_PROTOCOL ?= OPENSTACK_NOVA_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_CPU_RATIO ?= 1.0;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_RAM_RATIO ?= 1.0;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_VIRT_TYPE ?= 'kvm';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = nova
  note = Username for Nova to use to connect to it's database
}
final variable OPENSTACK_NOVA_DB_USERNAME ?= 'nova';
@use{
  type = string
  default = NOVA_DBPASS
  note = Password for Nova to use to connect to it's database
}
final variable OPENSTACK_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';
@use{
  type =
  default =
  note =
}
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_NOVA_DB_HOST,
    'dbname' , 'nova',
    'dbuser' , OPENSTACK_NOVA_DB_USERNAME,
    'dbpassword' , OPENSTACK_NOVA_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_NOVA_DB_HOST,
    'dbname' , 'nova-api',
    'dbuser' , OPENSTACK_NOVA_DB_USERNAME,
    'dbpassword' , OPENSTACK_NOVA_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
final variable OPENSTACK_NOVA_USERNAME ?= 'nova';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_PASSWORD ?= 'NOVA_PASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_OSAPI_PORT ?= 8774;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_EC2_PORT ?= 8773;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_METADATA_PORT ?= 8774;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_NOVNC_PORT ?= 6080;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NOVA_PORTS ?= list(OPENSTACK_NOVA_OSAPI_PORT, OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_NOVNC_PORT);

#############################
# Neutron specific variable #
#############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_NETWORK_PROVIDER ?= OPENSTACK_NEUTRON_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = neutron
  note = Username for Neutron to use to connect to it's database
}
final variable OPENSTACK_NEUTRON_DB_USERNAME ?= 'neutron';
@use{
  type = string
  default = NEUTRON_DBPASS
  note = Password for Neutron to use to connect to it's database
}
final variable OPENSTACK_NEUTRON_DB_PASSWORD ?= 'NEUTRON_DBPASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_NEUTRON_DB_HOST,
    'dbname' , 'neutron',
    'dbuser' , OPENSTACK_NEUTRON_DB_USERNAME,
    'dbpassword' , OPENSTACK_NEUTRON_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_USERNAME ?= 'neutron';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_PASSWORD ?= 'NEUTRON_PASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_MECHANISM ?= 'linuxbridge';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_NETWORK_TYPE ?= 'provider-service';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_OVERLAY_IP ?= PRIMARY_IP;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_BASE_MAC ?= null;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DVR_BASE_MAC ?= null;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_PORT ?= 9696;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_METADATA_PORT ?= 9697;
@use{
  type = boolean
  default = true
  note = Whether to enable Neutron for networking.
}
final variable OPENSTACK_NEUTRON_DEFAULT ?= true;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DEFAULT_NETWORKS ?= "192.168.0.0/24";
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DEFAULT_DHCP_POOL ?= dict(
  'start', '192.168.0.10',
  'end', '192.168.0.254',
);
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DEFAULT_GATEWAY ?= '192.168.0.1';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_NEUTRON_DEFAULT_NAMESERVER ?= '192.168.0.1';


############################
# Cinder specific variable #
############################

# Cinder Controller
@use{
  type = boolean
  default = false
  note = Whether to enable the cinder component
}
final variable OPENSTACK_CINDER_ENABLED ?= false;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = cinder
  note = Username for Cinder to use to connect to it's database
}
final variable OPENSTACK_CINDER_DB_USERNAME ?= 'cinder';
@use{
  type = string
  default = CINDER_DBPASS
  note = Password for Cinder to use to connect to it's database
}
final variable OPENSTACK_CINDER_DB_PASSWORD ?= 'CINDER_DBPASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_CINDER_DB_HOST,
    'dbname' , 'cinder',
    'dbuser' , OPENSTACK_CINDER_DB_USERNAME,
    'dbpassword' , OPENSTACK_CINDER_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_USERNAME ?= 'cinder';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_PASSWORD ?= 'CINDER_PASS';
@use{
  type =
  default =
  note =
}
# Cinder Storage
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_STORAGE_HOST ?= OPENSTACK_CINDER_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_STORAGE_TYPE ?= 'lvm';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CINDER_PORT ?= 8776;

############################
# Ceilometer specific variable #
############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_CONTROLLER_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = boolean
  default = false
  note = Whether to enable Meters for Ceilometer
}
final variable OPENSTACK_CEILOMETER_METERS_ENABLED ?= false;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = boolean
  default = false
  note = Whether to enable Ceilometer
}
final variable OPENSTACK_CEILOMETER_ENABLED ?= false;
@use{
  type = string
  default = ceilometer
  note = Username for Ceilometer to use to connect to it's mongodb database
}
final variable OPENSTACK_CEILOMETER_DB_USERNAME ?= 'ceilometer';
@use{
  type = string
  default = CEILOMETER_DBPASS
  note = Password for Ceilometer to use to connect to it's database
}
final variable OPENSTACK_CEILOMETER_DB_PASSWORD ?= 'CEILOMETER_DBPASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_DB ?= merge(SELF , dict(
    'dbhost' ,  OPENSTACK_CEILOMETER_DB_HOST,
    'dbname' , 'ceilometer',
    'dbuser' , OPENSTACK_CEILOMETER_DB_USERNAME,
    'dbpassword' , OPENSTACK_CEILOMETER_DB_PASSWORD,
    'dbprotocol' , 'mongodb',
    'dbport' , 27017,
));
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_USERNAME ?= 'ceilometer';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_PASSWORD ?= 'CEILOMETER_PASS';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEILOMETER_PORT ?= 8777;

##############################
# RabbitMQ specific variable #
##############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_RABBITMQ_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_RABBITMQ_USERNAME ?= 'openstack';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';

###########
# Horizon #
###########
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_HOST ?= OPENSTACK_CONTROLLER_HOST;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_PORT ?= {
  if (OPENSTACK_SSL) {
    port = 443;
  } else {
    port = 80
  };
};
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_ALLOWED_HOSTS ?= list('*');
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_DEFAULT_ROLE ?= 'user';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_SECRET_KEY ?= error('OPENSTACK_HORIZON_SECRET_KEY must be defined');
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_DEFAULT_DOMAIN ?= 'default';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_HORIZON_KEYSTONE_API_VERSION ?= '3';
@use{
  type = boolean
  default = false
  note = Enable multiple domains in Horizon
}
final variable OPENSTACK_HORIZON_MULTIDOMAIN_ENABLED ?= {
  if (OPENSTACK_KEYSTONE_IDENTITY_DRIVER == 'sql') {
    ;
  } else {
    true;
  };
};


##############################
# Metadata specific variable #
##############################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_METADATA_HOST ?= OPENSTACK_NOVA_CONTROLLER_HOST;

###########################
# CEPH Specific Variables #
###########################
@use{
  type = boolean
  default =
  note = Whether to enable ceph or not
}
final variable OPENSTACK_CEPH ?= false;
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_GLANCE_POOL ?= 'images';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_GLANCE_USER ?= 'glance';
@use{
  type =
  default =
  note =
}
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_GLANCE_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_CINDER_POOL ?= 'volumes';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_CINDER_USER ?= 'cinder';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_CINDER_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_CINDER_BACKUP_POOL ?= 'backups';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_CINDER_BACKUP_USER ?= 'cinder-backup';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_CINDER_BACKUP_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_NOVA_POOL ?= 'vms';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_NOVA_USER ?= 'cinder';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_NOVA_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_CEPH_LIBVIRT_SECRET ?= {
  if (OPENSTACK_CEPH) {
    error('OPENSTACK_CEPH_LIBVIRT_SECRET must be defined when OPENSTACK_CEPH is true');
  } else {
    null;
  };
};

########################################
# SNMPD configuration (for ceilometer) #
########################################
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_SNMPD_COMMUNITY ?= 'openstack';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_SNMPD_LOCATION ?= 'undef';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_SNMPD_CONTACT ?= 'root <root@localhost>';
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_SNMPD_IP ?= PRIMARY_IP;


#########################
# HA Specific Variables #
#########################

@use{
  type =
  default =
  note =
}
final variable OPENSTACK_RABBITMQ_CLUSTER_SECRET ?= if (OPENSTACK_HA) {error('OPENSTACK_RABBITMQ_CLUSTER_SECRET must be set for high availability');} else {null;};
@use{
  type = list
  default = OPENSTACK_RABBITMQ_HOST
  note = This is a list of hosts to be used for RabbitMQ
}
final variable OPENSTACK_RABBITMQ_HOSTS ?= list(OPENSTACK_RABBITMQ_HOST);
@use{
  type = list
  default = OPENSTACK_MEMCACHE_HOST
  note = This is a list of hosts to be used for Memcached
}
final variable OPENSTACK_MEMCACHE_HOSTS ?= dict(OPENSTACK_MEMCACHE_HOST:OPENSTACK_MEMCACHE_PORT);
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_FLOATING_IP ?= if (OPENSTACK_HA) {error('OPENSTACK_FLOATING_IP must be set for high availability');} else {null;};
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_KEEPALIVED_ROUTER_ID ?= if (OPENSTACK_HA) {error('OPENSTACK_FLOATING_IP must be set for high availability');} else {null;};
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_LOADBALANCER_MASTER ?= if (OPENSTACK_HA) {error('OPENSTACK_LOADBALANCER_MASTER must be set for high availability');} else {null;};
@use{
  type =
  default =
  note =
}
final variable OPENSTACK_SERVERS ?= if (OPENSTACK_HA) {error('OPENSTACK_SERVERS must be set for high availability');} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Keystone
}
final variable OPENSTACK_KEYSTONE_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Nova
}
final variable OPENSTACK_NOVA_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Neutron
}
final variable OPENSTACK_NEUTRON_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Cinder
}
final variable OPENSTACK_CINDER_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Ceilometer
}
final variable OPENSTACK_CEILOMETER_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Heat
}
final variable OPENSTACK_HEAT_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Glance
}
final variable OPENSTACK_GLANCE_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Horizon
}
final variable OPENSTACK_HORIZON_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
