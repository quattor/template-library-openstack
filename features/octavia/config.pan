unique template features/octavia/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Define Octavia types
include 'types/openstack/octavia';

# Include general openstack variables
include 'defaults/openstack/config';


@{
desc = password used to encrypt CA private key for both Octavia CAs
values = string, 32 characters long
default = none
required = yes
}
variable OS_OCTAVIA_CA_KEY_PASSWORD ?= error('You must define OS_OCTAVIA_CA_KEY_PASSWORD with the passaword to use when the Octavia CAs');
variable OS_OCTAVIA_CA_KEY_PASSWORD = if ( length(OS_OCTAVIA_CA_KEY_PASSWORD) == 32 ) {
    SELF;
} else {
    error('OS_OCTAVIA_HEARTBEAT_KEY must be 32-character long (%s given)', length(OS_OCTAVIA_CA_KEY_PASSWORD));
};


@{
desc = password used to encrypt amphora certificates/keys
values = string (strong and long >= 20 characters)
default = none
required = yes
}
variable OS_OCTAVIA_AMPHORA_CERT_PASSWORD ?= error('You must define OS_OCTAVIA_AMPHORA_CERT_PASSWORD with the password to use when creating the Octavia CAs');
variable OS_OCTAVIA_AMPHORA_CERT_PASSWORD = if ( length(OS_OCTAVIA_AMPHORA_CERT_PASSWORD) >= 20 ) {
    OS_OCTAVIA_AMPHORA_CERT_PASSWORD;
} else {
    error('OS_OCTAVIA_AMPHORA_CERT_PASSWORD must be at least 20-character long');
};


@{
desc = password used to encrypt the hearbeat messages
values = string (strong and long >= 20 characters)
default = none
required = yes
}
variable OS_OCTAVIA_HEARTBEAT_KEY ?= error('You must define OS_OCTAVIA_HEARTBEAT_KEY (20+ characters)');
variable OS_OCTAVIA_HEARTBEAT_KEY = if ( length(OS_OCTAVIA_HEARTBEAT_KEY) >= 20 ) {
    OS_OCTAVIA_HEARTBEAT_KEY;
} else {
    error('OS_OCTAVIA_HEARTBEAT_KEY must be at least 20-character long');
};


@{
desc = Octavia management network OpenStack ID
values = OpenStack ID
default = ffffff-ffff-ffff-ffff-ffffffffffff (invalid but allow to compile until it is created)
required = yes
}
variable OS_OCTAVIA_MGMT_NETWORK_OPENSTACK_ID ?= error(
    "%s\n%s",
    "You must define OS_OCTAVIA_MGMT_NETWORK_OPENSTACK_ID with the OpenStack ID of the management network",
    "If it has not yet been created, use ffffffff-ffff-ffff-ffff-ffffffffffff temporarily",
);


@{
desc = Openstack name of the octavia user SSH key be used by the service
values = string
default = none
required = yes
}
variable OS_OCTAVIA_SERVICE_SSH_KEY ?= error('You must define OS_OCTAVIA_SERVICE_SSH_KEY with the OpenStack name of the octavia user SSH key to use');


# For the following parameters, default values should be appropriate
include 'features/octavia/management-network/defaults';
variable OS_OCTAVIA_API_BIND_PORT ?= 9876;
variable OS_OCTAVIA_HEALTH_MANAGER_BIND_PORT ?= 5555;
variable OS_OCTAVIA_HEALTH_MANAGER_CONTROLLER_IP_PORT_LIST ?= list(format(
    '%s:%s',
    OS_OCTAVIA_MGMT_NETWORK_MGT_PORT_IP,
    OS_OCTAVIA_HEALTH_MANAGER_BIND_PORT,
));


# Add Glance bae RPMs
include 'features/octavia/rpms';

# Configgure Glance services
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'octavia-api/startstop' = true;
'octavia-health-manager/startstop' = true;
'octavia-housekeeping/startstop' = true;
'octavia-worker/startstop' = true;


##################################
# Configuration file for Octavia #
##################################

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/octavia/octavia.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/octavia-api' = 'restart';
'daemons/octavia-health-manager' = 'restart';
'daemons/octavia-housekeeping' = 'restart';
'daemons/octavia-worker' = 'restart';
bind '/software/components/metaconfig/services/{/etc/octavia/octavia.conf}/contents' = openstack_octavia_config;


# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [api_settings] section
'contents/api_settings/bind_port' = OS_OCTAVIA_API_BIND_PORT;

# [certificates] section
'contents/certificates/ca_certificate' = format('%s/server_ca.cert.pem', OS_OCTAVIA_CA_CERT_DIR);
'contents/certificates/ca_private_key' = format('%s/server_ca.key.pem', OS_OCTAVIA_CA_CERT_DIR);
'contents/certificates/ca_private_key_passphrase' = OS_OCTAVIA_CA_KEY_PASSWORD;
'contents/certificates/server_certs_key_passphrase' = OS_OCTAVIA_AMPHORA_CERT_PASSWORD;

# [controller_worker] section
'contents/controller_worker/amp_boot_network_list' = list(OS_OCTAVIA_MGMT_NETWORK_OPENSTACK_ID);
'contents/controller_worker/amp_ssh_key_name' = OS_OCTAVIA_SERVICE_SSH_KEY;
'contents/controller_worker/amp_image_owner_id' = openstack_add_if_defined(OS_PROJECT_SERVICE_ID);
'contents/controller_worker/client_ca' = format('%s/client_ca.cert.pem', OS_OCTAVIA_CA_CERT_DIR);

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/octavia', OS_OCTAVIA_DB_USERNAME, OS_OCTAVIA_DB_PASSWORD, OS_OCTAVIA_DB_HOST);

# [haproxy_amphora] section
'contents/haproxy_amphora/client_cert' = format('%s/client.cert-and-key.pem', OS_OCTAVIA_CA_CERT_DIR);
'contents/haproxy_amphora/server_ca' = format('%s/server_ca-chain.cert.pem', OS_OCTAVIA_CA_CERT_DIR);

# [health_manager] section
'contents/health_manager/bind_ip' = OS_OCTAVIA_MGMT_NETWORK_MGT_PORT_IP;
'contents/health_manager/bind_port' = OS_OCTAVIA_HEALTH_MANAGER_BIND_PORT;
'contents/health_manager/controller_ip_port_list' = OS_OCTAVIA_HEALTH_MANAGER_CONTROLLER_IP_PORT_LIST;
'contents/health_manager/heartbeat_key' = OS_OCTAVIA_HEARTBEAT_KEY;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');
'contents/keystone_authtoken/username' = OS_OCTAVIA_USERNAME;
'contents/keystone_authtoken/password' = OS_OCTAVIA_PASSWORD;

# [oslo_messaging] section
'contents/oslo_messaging/topic' = 'octavia_prov';

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [service_auth] section
'contents/service_auth' = value('/software/components/metaconfig/services/{/etc/octavia/octavia.conf}/contents/keystone_authtoken');
'contents/service_auth/region_name' = null;
'contents/service_auth/www_authenticate_uri' = null;


########################################################
# Configure script allowing to act as the octavia user #
########################################################
include 'features/octavia/octavia_rc_script';


######################################
# Deploy the octavia account SSH key #
######################################
include 'features/octavia/ssh-key';


########################################
# Configure Octavia management network #
########################################
include 'features/octavia/management-network/config';

#######################
# Octavia CA creation #
#######################

include 'features/octavia/dual_CA/config';


################################################
# Add instructions on how to initilize Octavia #
################################################

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/root/octavia-initialization.README}';
'config' = file_contents('features/octavia/octavia-initialization.README');
'perms' = '0644';


