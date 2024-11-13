unique template defaults/openstack/config;

#######################################
# Include site specific configuration #
#######################################
include 'site/openstack/config';

##################################
# Define site specific variables #
##################################
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

#################################
# Python modules root directory #
#################################
variable PYTHON_MODULES_ROOT_DIR ?= '/usr/lib/python3.9/site-packages';

#####################
# SSL configuration #
#####################
variable OS_SSL_USE_LETSENCRYPT ?= false;
# For Let's Encrypt, OS_SSL_CERTIFICATE_ROOT_DIR must be the directory containing all the certs
# (direcotry containing one directory per host)
variable OS_SSL_CERTIFICATE_ROOT_DIR ?= if ( OS_SSL_USE_LETSENCRYPT ) {
    error("OS_SSL_USE_LETSENCRYPT=true but OS_SSL_CERTIFICATE_ROOT_DIR undefined");
};
# If OS_SSL_CERTIFICATE_ROOT_DIR is defined, the actual certificate directory is 
# OS_SSL_CERTIFICATE_ROOT_DIR/FULL_HOSTNAME
variable OS_SSL_CERTIFICATE_DIR ?= if ( is_defined(OS_SSL_CERTIFICATE_ROOT_DIR) ) {
    format("%s/%s", OS_SSL_CERTIFICATE_ROOT_DIR, FULL_HOSTNAME);
} else {
    '/etc/certs';
};
# Excact name of the certificate/key file depends whether Let's Encrypt is used or not
variable OS_SSL_CERT ?= format(
    '%s/%s',
    OS_SSL_CERTIFICATE_DIR,
    if ( OS_SSL_USE_LETSENCRYPT ) 'fullchain.pem' else format("%s.crt", FULL_HOSTNAME),
);
variable OS_SSL_KEY ?= format(
    '%s/%s',
    OS_SSL_CERTIFICATE_DIR,
    if ( OS_SSL_USE_LETSENCRYPT ) 'privkey.pem' else format("%s.key", FULL_HOSTNAME),
);
# Default URL for the ACME challenge if Let's Encrypt is used (null if not used)
variable OS_SSL_ACME_CHALLENGE_URL ?= if ( OS_SSL_USE_LETSENCRYPT ) {
    toks = matches(OS_SSL_CERTIFICATE_ROOT_DIR, '^(/.*)/[\w\-]+$');
    if ( length(toks) == 2 ) {
        format("%s/acme-challenge", toks[1]);
    } else {
        error("Unable to retrieve parent of certificate directory (%s)", OS_SSL_CERTIFICATE_ROOT_DIR);
    };
} else {
    null;
};

#####################
# Region parameters #
#####################
variable OS_REGION_NAME ?= 'RegionOne';
variable OS_CLOUD_TIMEZONE ?= error("You must specify your cloud timezone with OS_CLOUD_TIMEZONE");

####################
# General variable #
####################
variable OS_ADMIN_TOKEN ?= error('OS_ADMIN_TOKEN must be declared');
variable OS_USERNAME ?= 'admin';
variable OS_PASSWORD ?= 'admin';
variable OS_METADATA_SECRET ?= error('OS_METADATA_SECRET must be declared');

variable OS_LOGGING_TYPE ?= 'file';
variable OS_AUTH_CLIENT_CONFIG ?= 'features/keystone/client/config';
variable OS_AUTH_CLIENT_MINIMAL_CONFIG ?= 'features/keystone/client/config-minimal';

# Define the following variable with the service project ID
# Used by some services like Octavia to do some filtering
# Normally optional
variable OS_PROJECT_SERVICE_ID ?= undef;


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
variable OS_GLANCE_CONTROLLER_HOST ?= error('OS_GLANCE_CONTROLLER_HOST must be declared');
variable OS_GLANCE_CONTROLLER_PROTOCOL ?= 'https';
variable OS_GLANCE_PUBLIC_HOST ?= OS_GLANCE_CONTROLLER_HOST;
variable OS_GLANCE_CONTROLLER_PORT ?= if ( OS_GLANCE_CONTROLLER_PROTOCOL == 'https' ) 9293 else 9292;
variable OS_GLANCE_PUBLIC_PORT ?= if ( OS_GLANCE_CONTROLLER_PROTOCOL == 'https' ) 9292 else null;
variable OS_GLANCE_DB_HOST ?= OS_DB_HOST;
variable OS_GLANCE_DB_USERNAME ?= 'glance';
variable OS_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';
variable OS_GLANCE_USERNAME ?= 'glance';
variable OS_GLANCE_PASSWORD ?= 'GLANCE_PASS';
# Site-specific policy for Glance
variable OS_GLANCE_POLICY ?= undef;

###################
# Magnum variales #
###################
variable OS_MAGNUM_PROTOCOL ?= 'https';
variable OS_MAGNUM_PUBLIC_HOST ?= if ( is_defined(OS_MAGNUM_HOST) ) {
    OS_MAGNUM_HOST;
} else {
    error('OS_MAGNUM_PUBLIC_HOST or OS_MAGNUM_HOST must be declared');
};
variable OS_MAGNUM_CONTROLLER_HOST ?= if ( is_defined(OS_MAGNUM_HOST) ) {
    OS_MAGNUM_HOST;
} else {
    error('OS_MAGNUM_CONTROLLER_HOST or OS_MAGNUM_HOST must be declared');
};
variable OS_MAGNUM_CONTROLLER_PORT ?= if ( OS_MAGNUM_PROTOCOL == 'https' ) 9512 else 9511;
variable OS_MAGNUM_PUBLIC_PORT ?= if ( OS_MAGNUM_PROTOCOL == 'https' ) 9511 else null;
variable OS_MAGNUM_DEFAULT_VOLUME_TYPE ?= 'magnum_volume_type';
variable OS_REGION_NAME ?= 'default';
variable OS_MAGNUM_DB_USERNAME ?= 'DB USER TO SET';
variable OS_MAGNUM_DB_PASSWORD ?= 'DB_MAGNUM_DBPASS';
variable OS_MAGNUM_DB_HOST ?= OS_DB_HOST;
variable OS_MAGNUM_DB_POOL_SIZE ?= 5;
variable OS_MAGNUM_ADMIN_USERNAME ?= 'magnum';
variable OS_MAGNUM_ADMIN_PASSWORD ?= 'MAGNUM_ADMNINPASS';
variable OS_MAGNUM_ADMIN_TENANT_NAME ?= 'service';
variable OS_MAGNUM_DOMAIN_ADMIN_USERNAME ?= 'magnum_domain_admin_user';
variable OS_MAGNUM_DOMAIN_ADMIN_PASSWORD ?= 'MAGNUM_DOMAIN_ADMIN_USER_PASS';
variable OS_MAGNUM_CLUSTER_USER_TRUST ?= true;
variable OS_MAGNUM_RPC_CONN_POOL_SIZE ?= 200;
variable OS_MAGNUM_USERNAME ?= 'magnum';
# Site-specific policy for Magnum
variable OS_MAGNUM_POLICY ?= undef;

##########################
# Heat specific variable #
##########################
variable OS_HEAT_PUBLIC_HOST ?= if ( is_defined(OS_HEAT_HOST) ) {
    OS_HEAT_HOST;
} else {
    error('OS_HEAT_PUBLIC_HOST or OS_HEAT_HOST must be declared');
};
variable OS_HEAT_CONTROLLER_HOST ?= if ( is_defined(OS_HEAT_HOST) ) {
    OS_HEAT_HOST;
} else {
    error('OS_HEAT_CONTROLLER_HOST or OS_HEAT_HOST must be declared');
};
variable OS_HEAT_PROTOCOL ?= 'https';
variable OS_HEAT_DB_HOST ?= OS_DB_HOST;
variable OS_HEAT_DB_POOL_SIZE ?= 5;
variable OS_HEAT_CONTROLLER_PORT ?= if ( OS_HEAT_PROTOCOL == 'https' ) 8005 else 8004;
variable OS_HEAT_PUBLIC_PORT ?= if ( OS_HEAT_PROTOCOL == 'https' ) 8004 else null;
variable OS_HEAT_ENABLED ?= false;
variable OS_HEAT_DB_USERNAME ?= 'heat';
variable OS_HEAT_DB_PASSWORD ?= 'HEAT_DBPASS';
variable OS_HEAT_USERNAME ?= 'heat';
variable OS_HEAT_PASSWORD ?= 'HEAT_PASS';
variable OS_HEAT_STACK_DOMAIN ?= 'heat';
variable OS_HEAT_USER_DOMAIN ?= 'default';
variable OS_HEAT_DOMAIN_ADMIN_USERNAME ?= 'heat_domain_admin';
variable OS_HEAT_DOMAIN_ADMIN_PASSWORD ?= 'HEAT_DOMAIN_ADMIN_PASS';
# Site-specific policy for Heat
variable OS_HEAT_POLICY ?= undef;

######################
# Barbican variables #
######################
variable OS_BARBICAN_PROTOCOL ?= 'https';
variable OS_BARBICAN_PUBLIC_HOST ?= if ( is_defined(OS_BARBICAN_HOST) ) {
    OS_BARBICAN_HOST;
} else {
    error('OS_BARBICAN_PUBLIC_HOST or OS_BARBICAN_HOST must be declared');
};
variable OS_BARBICAN_CONTROLLER_HOST ?= if ( is_defined(OS_BARBICAN_HOST) ) {
    OS_BARBICAN_HOST;
} else {
    error('OS_BARBICAN_CONTROLLER_HOST or OS_BARBICAN_HOST must be declared');
};
variable OS_BARBICAN_CONTROLLER_PORT ?= if ( OS_BARBICAN_PROTOCOL == 'https' ) 9312 else 9311;
variable OS_BARBICAN_PUBLIC_PORT ?= if ( OS_BARBICAN_PROTOCOL == 'https' ) 9311 else null;
variable OS_BARBICAN_ENABLED ?= false;
variable OS_BARBICAN_USERNAME ?= 'barbican';
variable OS_BARBICAN_PASSWORD ?= 'BARBICAN_PASS';
variable OS_BARBICAN_DB_USERNAME ?= 'barbican_user';
variable OS_BARBICAN_DB_PASSWORD ?= 'BARBICAN_REAL_PASS';
variable OS_BARBICAN_DB_HOST ?= OS_DB_HOST;
variable OS_BARBICAN_DB_POOL_SIZE ?= 5;
variable OS_BARBICAN_WSGI_POOL_SIZE ?= 100;
# Site-specific policy for Barbican
variable OS_BARBICAN_POLICY ?= undef;

##############################
# Keystone specific variable #
##############################
variable OS_KEYSTONE_CONTROLLER_PROTOCOL ?= 'https';
variable OS_KEYSTONE_PUBLIC_HOST ?= if ( is_defined(OS_KEYSTONE_HOST) ) {
    OS_KEYSTONE_HOST;
} else {
    error('OS_KEYSTONE_PUBLIC_HOST or OS_KEYSTONE_HOST must be declared');
};
variable OS_KEYSTONE_CONTROLLER_HOST ?= if ( is_defined(OS_KEYSTONE_HOST) ) {
    OS_KEYSTONE_HOST;
} else {
    error('OS_KEYSTONE_CONTROLLER_HOST or OS_KEYSTONE_HOST must be declared');
};
variable OS_KEYSTONE_CONTROLLER_STANDARD_PORT ?= if ( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' ) 5001 else 5000;
variable OS_KEYSTONE_PUBLIC_STANDARD_PORT ?= if ( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' ) 5000 else null;
variable OS_KEYSTONE_CONTROLLER_ADMIN_PORT ?= if ( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' ) 35358 else 35357;
variable OS_KEYSTONE_PUBLIC_ADMIN_PORT ?= if ( OS_KEYSTONE_CONTROLLER_PROTOCOL == 'https' ) 35357 else null;
variable OS_KEYSTONE_DB_HOST ?= OS_DB_HOST;
variable OS_KEYSTONE_DB_USERNAME ?= 'keystone';
variable OS_KEYSTONE_DB_PASSWORD ?= 'KEYSTONE_DBPASS';
variable OS_KEYSTONE_ENFORCE_SCOPE ?= null;
variable OS_KEYSTONE_ENFORCE_NEW_DEFAULTS ?= OS_KEYSTONE_ENFORCE_SCOPE;
variable OS_KEYSTONE_IDENTITY_DRIVER ?= 'sql';
variable OS_KEYSTONE_IDENTITY_LDAP_PARAMS ?= dict();
variable OS_KEYSTONE_TOKEN_AUTH_TYPE ?= 'password';
# Site-specific policy for Keystone
variable OS_KEYSTONE_POLICY ?= undef;

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
variable OS_NOVA_PROTOCOL ?= 'https';
variable OS_NOVA_PUBLIC_HOST ?= if ( is_defined(OS_NOVA_HOST) ) {
    OS_NOVA_HOST;
} else {
    error('OS_NOVA_PUBLIC_HOST or OS_NOVA_HOST must be declared');
};
variable OS_NOVA_CONTROLLER_HOST ?= if ( is_defined(OS_NOVA_HOST) ) {
    OS_NOVA_HOST;
} else {
    error('OS_NOVA_CONTROLLER_HOST or OS_NOVA_HOST must be declared');
};
# With https, do not use the port 8775 for the API as it is the default port for the metadata service
variable OS_NOVA_CONTROLLER_PORT ?= if ( OS_NOVA_PROTOCOL == 'https' ) 8773 else 8774;
variable OS_NOVA_PUBLIC_PORT ?= if ( OS_NOVA_PROTOCOL == 'https' ) 8774 else null;
variable OS_NOVA_METADATA_PORT ?= 8775;
variable OS_NOVA_NOVNC_PROTOCOL ?= OS_NOVA_PROTOCOL;
variable OS_NOVA_NOVNC_PUBLIC_HOST ?= OS_NOVA_PUBLIC_HOST;
# noVNC proxy has no reason to be access by the controller port if https used (nginx proxy)
variable OS_NOVA_NOVNC_CONTROLLER_HOST ?= if ( OS_NOVA_NOVNC_PROTOCOL == 'https' ) {
    '127.0.0.1';
} else {
    OS_NOVA_PUBLIC_HOST;
};
variable OS_NOVA_NOVNC_CONTROLLER_PORT ?= if ( OS_NOVA_PROTOCOL == 'https' ) 6081 else 6080;
variable OS_NOVA_NOVNC_PUBLIC_PORT ?= if ( OS_NOVA_PROTOCOL == 'https' ) 6080 else null;
# OS_NOVA_COMPUTE_POLICY muste be a policy file if a non-default policy is rquired
# Policy file extension must be json or yaml
variable OS_NOVA_COMPUTE_POLICY ?= undef;
variable OS_NOVA_RESUME_VM_ON_BOOT ?= false;
variable OS_NOVA_CPU_RATIO ?= 1.0;
variable OS_NOVA_CPU_WEIGHT_MULTIPLIER ?= 1.0;
variable OS_NOVA_DISK_WEIGHT_MULTIPLIER ?= 1.0;
variable OS_NOVA_RAM_RATIO ?= 1.0;
variable OS_NOVA_RAM_WEIGHT_MULTIPLIER ?= 1.0;
variable OS_NOVA_VIRT_TYPE ?= 'kvm';
variable OS_NOVA_MAX_CONCURRENT_SNAPSHOTS ?= value('/hardware/cpu/0/cores') * length(value('/hardware/cpu')) / 5;
variable OS_NOVA_DB_HOST ?= OS_DB_HOST;
variable OS_NOVA_DB_USERNAME ?= 'nova';
variable OS_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';
variable OS_NOVA_USERNAME ?= 'nova';
variable OS_NOVA_PASSWORD ?= 'NOVA_PASS';
variable OS_NOVA_METADATA_HOST ?= OS_NOVA_CONTROLLER_HOST;
variable OS_NOVA_UPGRADE_LEVELS ?= error(
    'OS_NOVA_UPGRADE_LEVELS must be defined to the appropriate value for the current OpenStack cluster'
);
# Ceph-related Variables
variable OS_NOVA_USE_CEPH ?= true;
variable OS_NOVA_CEPH_IMAGES_POOL ?= undef;
variable OS_NOVA_CEPH_IMAGES_USER ?= undef;
variable OS_NOVA_CEPH_IMAGES_CEPH_CONF ?= '/etc/ceph/ceph.conf';
# So-called Nova workarounds
# OS_NOVA_CPU_CAPABILITIES_CHECK must be set to false if CPU capabilities checks are failing for bad reasons...
variable OS_NOVA_CPU_CAPABILITIES_CHECK ?= true;
# Site-specific policy for Nova compute and controller
variable OS_NOVA_COMPUTE_POLICY ?= undef;
variable OS_NOVA_CONTROLLER_POLICY ?= undef;


#############################
# Neutron specific variable #
#############################
variable OS_NEUTRON_PROTOCOL ?= 'https';
variable OS_NEUTRON_PUBLIC_HOST ?= if ( is_defined(OS_NEUTRON_HOST) ) {
    OS_NEUTRON_HOST;
} else {
    error('OS_NEUTRON_PUBLIC_HOST or OS_NEUTRON_HOST must be declared');
};
variable OS_NEUTRON_CONTROLLER_HOST ?= if ( is_defined(OS_NEUTRON_HOST) ) {
    OS_NEUTRON_HOST;
} else {
    error('OS_NEUTRON_CONTROLLER_HOST or OS_NEUTRON_HOST must be declared');
};
variable OS_NEUTRON_CONTROLLER_PORT ?= if ( OS_NEUTRON_PROTOCOL == 'https' ) 9697 else 9696;
variable OS_NEUTRON_PUBLIC_PORT ?= if ( OS_NEUTRON_PROTOCOL == 'https' ) 9696 else null;
variable OS_NEUTRON_NETWORK_PROVIDER ?= OS_NEUTRON_CONTROLLER_HOST;
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
# Site-specific policy for Neutron
variable OS_NEUTRON_POLICY ?= undef;

############################
# Placement specific variable #
############################
variable OS_PLACEMENT_PROTOCOL ?= 'https';
variable OS_PLACEMENT_HOST ?= OS_NOVA_CONTROLLER_HOST;
variable OS_PLACEMENT_PUBLIC_HOST ?= if ( is_defined(OS_PLACEMENT_HOST) ) {
    OS_PLACEMENT_HOST;
} else {
    error('OS_PLACEMENT_PUBLIC_HOST or OS_PLACEMENT_HOST must be declared');
};
variable OS_PLACEMENT_CONTROLLER_HOST ?= if ( is_defined(OS_PLACEMENT_HOST) ) {
    OS_PLACEMENT_HOST;
} else {
    error('OS_PLACEMENT_CONTROLLER_HOST or OS_PLACEMENT_HOST must be declared');
};
variable OS_PLACEMENT_CONTROLLER_PORT ?= if ( OS_PLACEMENT_PROTOCOL == 'https' ) 8779 else 8778;
variable OS_PLACEMENT_PUBLIC_PORT ?= if ( OS_PLACEMENT_PROTOCOL == 'https' ) 8778 else null;
variable OS_PLACEMENT_DB_HOST ?= OS_DB_HOST;
variable OS_PLACEMENT_DB_USERNAME ?= 'placement';
variable OS_PLACEMENT_DB_PASSWORD ?= 'PLACEMENT_DBPASS';
variable OS_PLACEMENT_USERNAME ?= 'placement';
variable OS_PLACEMENT_PASSWORD ?= 'PLACEMENT_PASS';
# Site-specific policy for Placement
variable OS_PLACEMENT_POLICY ?= undef;

############################
# Cinder specific variable #
############################

# Cinder Controller
variable OS_CINDER_CONTROLLER_HOST ?= error('OS_CINDER_CONTROLLER_HOST must be declared');
variable OS_CINDER_CONTROLLER_PROTOCOL ?= 'https';
variable OS_CINDER_PUBLIC_HOST ?= OS_CINDER_CONTROLLER_HOST;
variable OS_CINDER_CONTROLLER_PORT ?= if ( OS_CINDER_CONTROLLER_PROTOCOL == 'https' ) 8777 else 8776;
variable OS_CINDER_PUBLIC_PORT ?= if ( OS_CINDER_CONTROLLER_PROTOCOL == 'https' ) 8776 else null;
variable OS_CINDER_ENABLED ?= false;
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
# Site-specfic policy for Cinder
variable OS_CINDER_POLICY ?= undef;

############################
# Ceilometer specific variable #
############################
variable OS_CEILOMETER_CONTROLLER_HOST ?= error('OS_CEILOMETER_CONTROLLER_HOST must be declared');
variable OS_CEILOMETER_CONTROLLER_PROTOCOL ?= 'https';
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
variable OS_RABBITMQ_HOST ?= error('OS_RABBITMQ_HOST must be declared');
variable OS_RABBITMQ_USERNAME ?= 'openstack';
variable OS_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';


###########
# Horizon #
###########
variable OS_HORIZON_HOST ?= if ( is_defined(OS_HORIZON_PUBLIC_NAMES[FULL_HOSTNAME]) ) {
    OS_HORIZON_PUBLIC_NAMES[FULL_HOSTNAME];
} else {
    debug("OS_HORIZON_PUBLIC_NAMES entry %s not found", FULL_HOSTNAME);
    FULL_HOSTNAME;
};
variable OS_HORIZON_PROTOCOL ?= 'https';
variable OS_HORIZON_INTERNAL_PORT ?= if ( OS_HORIZON_PROTOCOL == 'https' ) 8080 else 80;
variable OS_HORIZON_PUBLIC_PORT ?= if ( OS_HORIZON_PROTOCOL == 'https' ) 443 else null;
variable OS_HORIZON_ALLOWED_HOSTS ?= list(OS_HORIZON_HOST);
variable OS_HORIZON_CONFIGURE_LOCAL_SETTINGS ?= true;
variable OS_HORIZON_DEFAULT_ROLE ?= 'users';
variable OS_HORIZON_SECRET_KEY ?= error('OS_HORIZON_SECRET_KEY must be defined');
variable OS_HORIZON_DEFAULT_DOMAIN ?= 'default';
variable OS_HORIZON_ROOT_URL ?= '/dashboard';
# OS_HORIZON_USER_URL: URL redirected to the dashboard
variable OS_HORIZON_USER_URL ?= '/';
variable OS_HORIZON_KEYSTONE_API_VERSION ?= 3;
variable OS_HORIZON_MULTIDOMAIN_ENABLED ?= if (OS_KEYSTONE_IDENTITY_DRIVER == 'sql') {
    false;
} else {
    true;
};


###########
# Octavia #
###########
variable OS_OCTAVIA_CONTROLLER_HOST ?= error('OS_OCTAVIA_CONTROLLER_HOST must be declared');
variable OS_OCTAVIA_PUBLIC_HOST ?= OS_OCTAVIA_CONTROLLER_HOST;
variable OS_OCTAVIA_PROTOCOL ?= 'https';
variable OS_OCTAVIA_CONTROLLER_PORT ?= if ( OS_OCTAVIA_PROTOCOL == 'https' ) 9877 else 9876;
variable OS_OCTAVIA_PUBLIC_PORT ?= if ( OS_OCTAVIA_PROTOCOL == 'https' ) 9876 else null;
variable OS_OCTAVIA_DB_HOST ?= OS_DB_HOST;
variable OS_OCTAVIA_DB_PASSWORD ?= 'OCTAVIA_DBPASS';
variable OS_OCTAVIA_DB_USERNAME ?= 'octavia';
variable OS_OCTAVIA_PASSWORD ?= 'OCTAVIA_PASS';
variable OS_OCTAVIA_USERNAME ?= 'octavia';
variable OS_OCTAVIA_CA_CERT_DIR ?= '/etc/octavia/certs';
# Site-specific policy for Octavia
variable OS_OCTAVIA_POLICY ?= undef;


########################################
# SNMPD configuration (for ceilometer) #
########################################
variable OS_SNMPD_COMMUNITY ?= 'openstack';
variable OS_SNMPD_LOCATION ?= 'undef';
variable OS_SNMPD_CONTACT ?= 'root <root@localhost>';
variable OS_SNMPD_IP ?= PRIMARY_IP;
