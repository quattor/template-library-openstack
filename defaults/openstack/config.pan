unique template defaults/openstack/config;

include 'defaults/openstack/functions';

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');
@use{
  type = ipaddress
  note = This is the primary IP address of the Host
}
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

@use{
  type = boolean
  default = false
  note = Set this to enable each OpenStack service to be run on multiple hosts.
}
variable OPENSTACK_HA ?= false;

@use{
  type = dict
  note = A dictionary of Openstack Servers and IP Addresses
}
variable OPENSTACK_SERVERS ?= error('OPENSTACK_SERVERS must be set');

############################
# Active SSL configuration #
############################
@use{
  type = boolean
  default = false
  note = Set this to true to enable SSL on various services
}
variable OPENSTACK_SSL ?= false;
@use{
  type = string
  note = This is the path of the SSL Cert
}
variable OPENSTACK_SSL_CERT ?= '/etc/certs/' + FULL_HOSTNAME + '.crt';
@use{
  type = string
  note = This is the path of the SSL Key
}
variable OPENSTACK_SSL_KEY ?= '/etc/certs/' + FULL_HOSTNAME + '.key';
@use{
  type = string
  default = null
  note = This is the path of the SSL Chain, if required
}
variable OPENSTACK_SSL_CHAIN ?= null;

##############
# RegionName #
##############
@use{
  type = string
  default = RegionOne
  note = The Region to be used by OpenStack
}
variable OPENSTACK_REGION_NAME ?= 'RegionOne';

############################################
# Virtual Machine interface for hypervisor #
############################################
@use{
  type = string
  default = boot_nic()
  note = The interface that openstack will be bound to.
}
variable OPENSTACK_INTERFACE_MAPPING ?= boot_nic();

# Force user to specify OPENSTACK_ADMIN_TOKEN
@use{
  type = string
  note = The admin token used for initial setup, will error if not set.
}
variable OPENSTACK_ADMIN_TOKEN ?= error('OPENSTACK_ADMIN_TOKEN must be declared');
@use{
  type = string
  default = admin
  note = The OpenStack Admin user.
}
variable OPENSTACK_USERNAME ?= 'admin';
@use{
  type = string
  default = admin
  note = The OpenStack Admin user's password.
}
variable OPENSTACK_PASSWORD ?= 'admin';
@use{
  type = string
  note = the metadata secret used for connecting Horizon
}
variable OPENSTACK_METADATA_SECRET ?= error('OPENSTACK_METADATA_SECRET must be declared');

##########################################
# NODE_TYPE is 'compute' or 'controller' #
##########################################
@use{
  type = string
  default = compute
  note = Sets whether a host is a compute node, network node or controller node
}
variable OPENSTACK_NODE_TYPE ?= 'compute';
@use{
  type = string
  default = file
  note = The type of logging used by OpenStack
}
variable OPENSTACK_LOGGING_TYPE ?= 'file';
@use{
  type = string
  default =
  note = The file to use for the Keystone Client Authentication schema
}
variable OPENSTACK_AUTH_CLIENT_CONFIG ?= 'features/keystone/client/config';

###############################
# Define OPENSTACK_CONTROLLER_HOST  #
##############################
@use{
  type = string
  default =
  note = The host to be used as the controller, will generate an error if not set. This is expected to be the DNS for the load balancer in HA environments
}
variable OPENSTACK_CONTROLLER_HOST ?= error('OPENSTACK_CONTROLLER_HOST must be declared');
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_CONTROLLER_PROTOCOL ?= if (OPENSTACK_SSL) {
  'https';
} else {
  'http';
};

#############################
# Mariadb specific variable #
#############################
@use{
  type = host
  note = The main database host to use
}
variable OPENSTACK_DB_HOST ?= 'localhost';
@use{
  type = string
  default = root
  note = The user to be used to create databases
}
variable OPENSTACK_DB_ADMIN_USERNAME ?= 'root';
@use{
  type = string
  default = root
  note = the password of the user to be used to create databases
}
variable OPENSTACK_DB_ADMIN_PASSWORD ?= 'root';

############################
# Glance specific variable #
############################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Glance
}
variable OPENSTACK_GLANCE_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_GLANCE_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Glance database
}
variable OPENSTACK_GLANCE_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = glance
  note = Username for Glance to use to connect to it's database
}
variable OPENSTACK_GLANCE_DB_USERNAME ?= 'glance';
@use{
  type = string
  default = GLANCE_DBPASS
  note = Password for Glance to use to connect to it's database
}
variable OPENSTACK_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';

@use{
  type = string
  default = null
  note = Tells glance whether to support multiple backends
}
variable OPENSTACK_GLANCE_MULTIPLE_LOCATIONS ?= null;
@use{
  type = string
  default = glance
  note = The user to run Glance under
}
variable OPENSTACK_GLANCE_USERNAME ?= 'glance';
@use{
  type = string
  default = GLANCE_PASS
  note = The password to use for Glance
}
variable OPENSTACK_GLANCE_PASSWORD ?= 'GLANCE_PASS';
@use{
  type = string
  note = the path to be used for the glance image store
}
variable OPENSTACK_GLANCE_STORE_DIR ?= '/var/lib/glance/images/';
@use{
  type = long
  default = 9292
  note = The port to be used for Glance
}
variable OPENSTACK_GLANCE_PORT ?= 9292;

############################
# Heat specific variable #
############################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Heat
}

variable OPENSTACK_HEAT_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_HEAT_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Heat database
}
variable OPENSTACK_HEAT_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = heat
  note = Username for Heat to use to connect to it's database
}
variable OPENSTACK_HEAT_DB_USERNAME ?= 'heat';
@use{
  type = string
  default = HEAT_DBPASS
  note = Password for Heat to use to connect to it's database
}
variable OPENSTACK_HEAT_DB_PASSWORD ?= 'HEAT_DBPASS';

@use{
  type = boolean
  default = false
  note = Whether to enable the Heat component.
}
variable OPENSTACK_HEAT_ENABLED ?= false;

@use{
  type = string
  default = heat
  note = The user for Heat to run under
}
variable OPENSTACK_HEAT_USERNAME ?= 'heat';
@use{
  type = string
  default = HEAT_PASS
  note = The password to use for Heat
}
variable OPENSTACK_HEAT_PASSWORD ?= 'HEAT_PASS';
@use{
  type = string
  default = heat
  note = The domain to be used for heat stacks
}
variable OPENSTACK_HEAT_STACK_DOMAIN ?= 'heat';
@use{
  type = string
  default = heat_domain_admin
  note = The user to use as heat domain admin
}
variable OPENSTACK_HEAT_DOMAIN_ADMIN_USERNAME ?= 'heat_domain_admin';
@use{
  type = string
  default = HEAT_DOMAIN_ADMIN_PASS
  note = The password for the heat domain admin
}
variable OPENSTACK_HEAT_DOMAIN_ADMIN_PASSWORD ?= 'HEAT_DOMAIN_ADMIN_PASS';
@use{
  type = long
  default = 8000
  note = The port for Heat Cloud Formation
}
variable OPENSTACK_HEAT_CFN_PORT ?= 8000;
@use{
  type = long
  default = 8004
  note = The port for Heat
}
variable OPENSTACK_HEAT_PORT ?= 8004;
@use{
  type = long
  note = A list of ports which heat uses
}
variable OPENSTACK_HEAT_PORTS ?= list(OPENSTACK_HEAT_PORT,OPENSTACK_HEAT_CFN_PORT);

##############################
# Keystone specific variable #
##############################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Keystone
}
variable OPENSTACK_KEYSTONE_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_KEYSTONE_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Keystone database
}
variable OPENSTACK_KEYSTONE_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = keystone
  note = Username for Keystone to use to connect to it's database
}
variable OPENSTACK_KEYSTONE_DB_USERNAME ?= 'keystone';
@use{
  type = string
  default = KEYSTONE_DBPASS
  note = Password for Keystone to use to connect to it's database
}
variable OPENSTACK_KEYSTONE_DB_PASSWORD ?= 'KEYSTONE_DBPASS';

@use{
  type = string
  default = sql
  note = The default identity driver to use
}
variable OPENSTACK_KEYSTONE_IDENTITY_DRIVER ?= 'sql';
@use{
  type = dict
  note = A Dictionary which provides ldap attributes to use for ldap authentication
}
variable OPENSTACK_KEYSTONE_IDENTITY_LDAP_PARAMS ?= dict();
@use{
  type = long
  default = 5000
  note = The port to use for Keystones api
}
variable OPENSTACK_KEYSTONE_PORT ?= 5000;
@use{
  type = long
  default = 35357
  note = The port to use for Keystones admin port
}
variable OPENSTACK_KEYSTONE_ADMIN_PORT ?= 35357;
@use{
  type = list
  note = A list of ports used by keystone
}
variable OPENSTACK_KEYSTONE_PORTS ?= list(OPENSTACK_KEYSTONE_PORT,OPENSTACK_KEYSTONE_ADMIN_PORT);
@use{
  type = string
  default = uuid
  note = The type of tokens that keystone will use
}
variable OPENSTACK_KEYSTONE_TOKEN_PROVIDER ?= 'uuid';
@use{
  type = string
  default = memcache
  note = The driver keystone will use for token caching and sharing
}
variable OPENSTACK_KEYSTONE_TOKEN_DRIVER ?= 'memcache';

#############################
# Memcache specfic variable #
#############################
@use{
  type = dict
  default = localhost:11211
  note = A dictionary of hosts and ports to use for memcached
}
variable OPENSTACK_MEMCACHE_HOSTS ?= dict('localhost','11211');

#############################
# MongoDB specfic variable #
#############################
@use{
  type = long
  default = 2
  note = The version of MongoDB to use
}
variable OPENSTACK_MONGODB_VERSION ?= 2;
@use{
  type = string
  note = The path where mongodb will store the databases
}
variable OPENSTACK_MONGODB_DBPATH ?= '/var/mongodb';

##########################
# Nova specific variable #
##########################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Nova
}
variable OPENSTACK_NOVA_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_NOVA_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = string
  default = OPENSTACK_NOVA_CONTROLLER_PROTOCOL
  note = The protocol used for communicating with NoVNC
}
variable OPENSTACK_NOVA_VNC_PROTOCOL ?= OPENSTACK_NOVA_CONTROLLER_PROTOCOL;
@use{
  type = float
  default = 1.0
  note = The ratio at which to commit or overcommit CPU cores
}
variable OPENSTACK_NOVA_CPU_RATIO ?= 1.0;
@use{
  type = float
  default = 1.0
  note = The ratio at which to commit or overcommit Memory
}
variable OPENSTACK_NOVA_RAM_RATIO ?= 1.0;
@use{
  type = string
  default = kvm
  note = The type of virtualisation to use
}
variable OPENSTACK_NOVA_VIRT_TYPE ?= 'kvm';
@use{
  type = boolean
  default = false
  note = Whether Nova resumes VMs
}
variable OPENSTACK_NOVA_RESUME_VM_ON_BOOT ?= false;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Nova database
}
variable OPENSTACK_NOVA_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = nova
  note = Username for Nova to use to connect to it's database
}
variable OPENSTACK_NOVA_DB_USERNAME ?= 'nova';
@use{
  type = string
  default = NOVA_DBPASS
  note = Password for Nova to use to connect to it's database
}
variable OPENSTACK_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';


@use{
  type = string
  default = nova
  note = The user to run Nova under
}
variable OPENSTACK_NOVA_USERNAME ?= 'nova';
@use{
  type = string
  default = NOVA_PASS
  note = The password to use for Nova
}
variable OPENSTACK_NOVA_PASSWORD ?= 'NOVA_PASS';
@use{
  type = long
  default = 8774
  note = The port to use for the Nova API
}
variable OPENSTACK_NOVA_OSAPI_PORT ?= 8774;
@use{
  type = long
  default = 8773
  note = The port to be used for the Nova EC2 API
}
variable OPENSTACK_NOVA_EC2_PORT ?= 8773;
@use{
  type = long
  default = 8774
  note = The port to be used for Nova Metadata
}
variable OPENSTACK_NOVA_METADATA_PORT ?= 8774;
@use{
  type = long
  default = 6080
  note = The port to be used for the NoVNC proxy
}
variable OPENSTACK_NOVA_NOVNC_PORT ?= 6080;
@use{
  type = list
  note = A list of ports used by Nova
}
variable OPENSTACK_NOVA_PORTS ?= list(OPENSTACK_NOVA_OSAPI_PORT, OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_NOVNC_PORT);

#############################
# Neutron specific variable #
#############################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Neutron
}
variable OPENSTACK_NEUTRON_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = string
  note = The host to use a network node for Neutron
}
variable OPENSTACK_NEUTRON_NETWORK_PROVIDER ?= openstack_get_controller_host(OPENSTACK_NEUTRON_SERVERS);
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_NEUTRON_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Neutron database
}
variable OPENSTACK_NEUTRON_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = neutron
  note = Username for Neutron to use to connect to it's database
}
variable OPENSTACK_NEUTRON_DB_USERNAME ?= 'neutron';
@use{
  type = string
  default = NEUTRON_DBPASS
  note = Password for Neutron to use to connect to it's database
}
variable OPENSTACK_NEUTRON_DB_PASSWORD ?= 'NEUTRON_DBPASS';

@use{
  type = string
  default = neutron
  note = The user to run Neutron under
}
variable OPENSTACK_NEUTRON_USERNAME ?= 'neutron';
@use{
  type = string
  default = NEUTRON_PASS
  note = The password to use for Neutron
}
variable OPENSTACK_NEUTRON_PASSWORD ?= 'NEUTRON_PASS';
@use{
  type = string
  default = linuxbridge
  note = The mechanism to use for networking - currently linuxbridge and OpenVSwitch are supported
}
variable OPENSTACK_NEUTRON_MECHANISM ?= 'linuxbridge';
@use{
  type = string
  default = provider-service
  note = The type of networking to use. Options are provider-service or self-service
}
variable OPENSTACK_NEUTRON_NETWORK_TYPE ?= 'provider-service';
@use{
  type = ipaddress
  default = PRIMARY_IP
  note = The ipaddress for the node to use as the endpoint for tunnels
}
variable OPENSTACK_NEUTRON_OVERLAY_IP ?= PRIMARY_IP;
@use{
  type = macaddress
  default = null
  note = The base mac address to use in the form XX:XX:XX:00:00:00 or XX:XX:XX:XX:00:00
}
variable OPENSTACK_NEUTRON_BASE_MAC ?= null;
@use{
  type = macaddress
  default = null
  note = The base mac address to use for Distributed Virtual Routing in the form XX:XX:XX:00:00:00 or XX:XX:XX:XX:00:00
}
variable OPENSTACK_NEUTRON_DVR_BASE_MAC ?= null;
@use{
  type = long
  default = 9696
  note = The port to use for the Neutron API
}
variable OPENSTACK_NEUTRON_PORT ?= 9696;
@use{
  type = long
  default = 9697
  note = The port to use for Neutron Metadata
}
variable OPENSTACK_NEUTRON_METADATA_PORT ?= 9697;
@use{
  type = boolean
  default = true
  note = Whether to enable Neutron for networking.
}
variable OPENSTACK_NEUTRON_DEFAULT ?= true;
@use{
  type = cidr
  note = The cidr to use for the default network
}
variable OPENSTACK_NEUTRON_DEFAULT_NETWORKS ?= "192.168.0.0/24";
@use{
  type = dict
  note = A dictionary defining the start and end of the ip allocation pool for the default network
}
variable OPENSTACK_NEUTRON_DEFAULT_DHCP_POOL ?= dict(
  'start', '192.168.0.10',
  'end', '192.168.0.254',
);
@use{
  type = ipaddress
  note = The default gateway to use for the default network
}
variable OPENSTACK_NEUTRON_DEFAULT_GATEWAY ?= '192.168.0.1';
@use{
  type = ipaddress
  note = The dns server to use for the default network.
}
variable OPENSTACK_NEUTRON_DEFAULT_NAMESERVER ?= '192.168.0.1';


############################
# Cinder specific variable #
############################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Cinder
}
variable OPENSTACK_CINDER_SERVERS ?= OPENSTACK_SERVERS;
# Cinder Controller
@use{
  type = boolean
  default = false
  note = Whether to enable the cinder component
}
variable OPENSTACK_CINDER_ENABLED ?= false;
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_CINDER_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Cinder database
}
variable OPENSTACK_CINDER_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = string
  default = cinder
  note = Username for Cinder to use to connect to it's database
}
variable OPENSTACK_CINDER_DB_USERNAME ?= 'cinder';
@use{
  type = string
  default = CINDER_DBPASS
  note = Password for Cinder to use to connect to it's database
}
variable OPENSTACK_CINDER_DB_PASSWORD ?= 'CINDER_DBPASS';

@use{
  type = string
  default = cinder
  note = The user to run Cinder under
}
variable OPENSTACK_CINDER_USERNAME ?= 'cinder';
@use{
  type = string
  default = CINDER_PASS
  note = The password to use for Cinder
}
variable OPENSTACK_CINDER_PASSWORD ?= 'CINDER_PASS';

# Cinder Storage
@use{
  type = hostname
  note = The host to be used for cinder storage
}
variable OPENSTACK_CINDER_STORAGE_HOST ?= openstack_get_controller_host(OPENSTACK_CINDER_SERVERS);
@use{
  type = string
  default = lvm
  note = The type of cinder storage backend, lvm and ceph are currently supported
}
variable OPENSTACK_CINDER_STORAGE_TYPE ?= 'lvm';
@use{
  type = long
  default = 8776
  note = The port to use for the Cinder API
}
variable OPENSTACK_CINDER_PORT ?= 8776;

############################
# Ceilometer specific variable #
############################
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Ceilometer
}
variable OPENSTACK_CEILOMETER_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = string
  default = http
  note = This is the protocol used for communicating with OpenStack APIs, is set automatically based on the value of OPENSTACK_SSL
}
variable OPENSTACK_CEILOMETER_CONTROLLER_PROTOCOL ?= OPENSTACK_CONTROLLER_PROTOCOL;
@use{
  type = boolean
  default = false
  note = Whether to enable Meters for Ceilometer
}
variable OPENSTACK_CEILOMETER_METERS_ENABLED ?= false;
@use{
  type = hostname
  default = OPENSTACK_DB_HOST
  note = The host used for the Ceilometer database
}
variable OPENSTACK_CEILOMETER_DB_HOST ?= OPENSTACK_DB_HOST;
@use{
  type = boolean
  default = false
  note = Whether to enable Ceilometer
}
variable OPENSTACK_CEILOMETER_ENABLED ?= false;
@use{
  type = string
  default = ceilometer
  note = Username for Ceilometer to use to connect to it's mongodb database
}
variable OPENSTACK_CEILOMETER_DB_USERNAME ?= 'ceilometer';
@use{
  type = string
  default = CEILOMETER_DBPASS
  note = Password for Ceilometer to use to connect to it's database
}
variable OPENSTACK_CEILOMETER_DB_PASSWORD ?= 'CEILOMETER_DBPASS';

@use{
  type = string
  default = ceilometer
  note = The user to run Ceilometer under
}
variable OPENSTACK_CEILOMETER_USERNAME ?= 'ceilometer';
@use{
  type = string
  default = CEILOMETER_PASS
  note = The password to use for Ceilometer
}
variable OPENSTACK_CEILOMETER_PASSWORD ?= 'CEILOMETER_PASS';
@use{
  type = long
  default = 8777
  note = The port to use for the Ceilometer API
}
variable OPENSTACK_CEILOMETER_PORT ?= 8777;

##############################
# RabbitMQ specific variable #
##############################

@use{
  type = string
  default =
  note = The port to be used for rabbitmq
}
variable OPENSTACK_RABBITMQ_PORT ?= 5672;
@use{
  type = list
  default = OPENSTACK_RABBITMQ_HOST
  note = This is a list of hosts to be used for RabbitMQ
}
variable OPENSTACK_RABBITMQ_HOSTS ?= dict('localhost',OPENSTACK_RABBITMQ_PORT);
@use{
  type = string
  default = openstack
  note = The user to be used to connect to rabbitmq
}
variable OPENSTACK_RABBITMQ_USERNAME ?= 'openstack';
@use{
  type = string
  default = RABBIT_PASS
  note = The password to use to connect to rabbitmq
}
variable OPENSTACK_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';
@use{
  type = string
  note = The secret to be used for HA RabbitMQ Cluster
}
variable OPENSTACK_RABBITMQ_CLUSTER_SECRET ?= if (OPENSTACK_HA) {error('OPENSTACK_RABBITMQ_CLUSTER_SECRET must be set for high availability');} else {null;};

###########
# Horizon #
###########
@use{
  type = dict
  note = A dictionary with the hostname as the key and the IP address as the value to be used by HAProxy for Horizon
}
variable OPENSTACK_HORIZON_SERVERS ?= OPENSTACK_SERVERS;
@use{
  type = long
  default = 80
  note = The port to use for Horizon, can be controlled by setting OPENSTACK_SSL
}
variable OPENSTACK_HORIZON_PORT ?= {
  if (OPENSTACK_SSL) {
    port = 443;
  } else {
    port = 80
  };
};
@use{
  type = list
  default = list(*)
  note = The list of hosts allowed to talk to Horizone, defaults to all hosts.
}
variable OPENSTACK_HORIZON_ALLOWED_HOSTS ?= list('*');
@use{
  type = string
  default = user
  note = The role to be used by horizon as the devfault
}
variable OPENSTACK_HORIZON_DEFAULT_ROLE ?= 'user';
@use{
  type = string
  note = The Secret Key for Horizon to use to talk to Keystone
}
variable OPENSTACK_HORIZON_SECRET_KEY ?= error('OPENSTACK_HORIZON_SECRET_KEY must be defined');
@use{
  type = string
  default = default
  note = The domain for Horizon to use as default.
}
variable OPENSTACK_HORIZON_DEFAULT_DOMAIN ?= 'default';
@use{
  type = string
  default = /dashboard/
  note = The webroot for Horizon to use.
}
variable OPENSTACK_HORIZON_WEBROOT ?= '/dashboard/';
@use{
  type = string
  default = null
  note = The slug to use as the default dashboard and panel
}
variable OPENSTACK_HORIZON_DEFAULT_DASHBOARD ?= null;
@use{
  type = list
  default = null
  note = a list of dictionaries of available themes
}
variable OPENSTACK_HORIZON_AVAILABLE_THEMES ?= null;
@use{
  type = string
  default = null
  note = The theme to use as the default
}
variable OPENSTACK_HORIZON_DEFAULT_THEME ?= null;
@use{
  type = long
  default = 3
  note = The Version of the Keystone Identity api for Horizon to use.
}
variable OPENSTACK_HORIZON_KEYSTONE_API_VERSION ?= '3';
@use{
  type = string
  default = False
  note = Whether to require a keypair to be entered in order to create virtual machines
}
variable OPENSTACK_HORIZON_REQUIRES_KEYPAIR ?= 'False';
@use{
  type = string
  default = False
  note = Whether to default to using config drives in instance creation
}
variable OPENSTACK_HORIZON_ENABLE_CONFIG_DRIVE ?= 'False';
@use{
  type = boolean
  default = false
  note = Enable multiple domains in Horizon
}
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
@use{
  type = hostname
  note = the host to use for Metadata
}
variable OPENSTACK_METADATA_HOST ?= openstack_get_controller_host(OPENSTACK_NOVA_SERVERS);

###########################
# CEPH Specific Variables #
###########################
@use{
  type = boolean
  default = false
  note = Whether to enable ceph or not
}
variable OPENSTACK_CEPH ?= false;
@use{
  type = boolean
  default = false
  note = Whether to enable ceph for glance or not
}
variable OPENSTACK_CEPH_GLANCE ?= OPENSTACK_CEPH;
@use{
  type = boolean
  default = false
  note = Whether to enable ceph for nova or not
}
variable OPENSTACK_CEPH_NOVA ?= OPENSTACK_CEPH;
@use{
  type = boolean
  default = false
  note = Whether to enable ceph for cinder or not
}
variable OPENSTACK_CEPH_CINDER ?= OPENSTACK_CEPH;
@use{
  type = string
  default = images
  note = The ceph pool to be used for Glance images
}
variable OPENSTACK_CEPH_GLANCE_POOL ?= 'images';
@use{
  type = string
  default = glance
  note = the ceph user for glance to use to connect to ceph
}
variable OPENSTACK_CEPH_GLANCE_USER ?= 'glance';
@use{
  type = path
  note = The path of the ceph.conf file
}
variable OPENSTACK_CEPH_GLANCE_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type = string
  default = volumes
  note = The ceph pool to be used for cinder volumes
}
variable OPENSTACK_CEPH_CINDER_POOL ?= 'volumes';
@use{
  type = string
  default = cinder
  note = The user for cinder to use to connect to ceph.
}
variable OPENSTACK_CEPH_CINDER_USER ?= 'cinder';
@use{
  type = path
  note = The path of the ceph.conf
}
variable OPENSTACK_CEPH_CINDER_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type = string
  default = backups
  note = The pool to use for cinder backups
}
variable OPENSTACK_CEPH_CINDER_BACKUP_POOL ?= 'backups';
@use{
  type = string
  default = cinder-backup
  note = the ceph user to use for Cinder backups
}
variable OPENSTACK_CEPH_CINDER_BACKUP_USER ?= 'cinder-backup';
@use{
  type = path
  note = The path to the ceph.conf file
}
variable OPENSTACK_CEPH_CINDER_BACKUP_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type = string
  default = vms
  note = The ceph pool to use for nova to use for VMs
}
variable OPENSTACK_CEPH_NOVA_POOL ?= 'vms';
@use{
  type = string
  default = cinder
  note = The ceph user to use for nova to connect to ceph
}
variable OPENSTACK_CEPH_NOVA_USER ?= 'cinder';
@use{
  type = path
  note = The path to the ceph.conf file
}
variable OPENSTACK_CEPH_NOVA_CEPH_CONF ?= '/etc/ceph/ceph.conf';
@use{
  type = string
  note = The uuid of the libvirt secret for nova to use for ephemeral disks
}
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
@use{
  type = To be completed
  default = To be completed
  note = To be completed
}
variable OPENSTACK_SNMPD_COMMUNITY ?= 'openstack';
@use{
  type = To be completed
  default = To be completed
  note = To be completed
}
variable OPENSTACK_SNMPD_LOCATION ?= 'undef';
@use{
  type = To be completed
  default = To be completed
  note = To be completed
}
variable OPENSTACK_SNMPD_CONTACT ?= 'root <root@localhost>';
@use{
  type = To be completed
  default = To be completed
  note = To be completed
}
variable OPENSTACK_SNMPD_IP ?= PRIMARY_IP;


#########################
# HA Specific Variables #
#########################

@use{
  type = ipaddress
  note = The floating ip address to use for keepalived
}
variable OPENSTACK_KEEPALIVED_FLOATING_IP ?= if (OPENSTACK_HA) {error('OPENSTACK_KEEPALIVED_FLOATING_IP must be set for high availability');} else {null;};
@use{
  type = long
  note = The router id to be used for keepalived. Must be unique within broadcast domains.
}
variable OPENSTACK_KEEPALIVED_ROUTER_ID ?= if (OPENSTACK_HA) {error('OPENSTACK_KEEPALIVED_FLOATING_IP must be set for high availability');} else {null;};
@use{
  type = hostname
  note = The host to use as the master loadbalancer in active passive modes
}
variable OPENSTACK_LOADBALANCER_MASTER ?= if (OPENSTACK_HA) {error('OPENSTACK_LOADBALANCER_MASTER must be set for high availability');} else {null;};

include 'defaults/openstack/dicts';
