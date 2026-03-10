unique template features/barbican/config;

variable OS_NODE_SERVICES = append('barbican');

final variable OS_BARBICAN_API_PROCESSES ?= 8;
final variable OS_BARBICAN_LOG_DIR ?= '/var/log/barbican';
final variable OS_BARBICAN_GROUP ?= OS_BARBICAN_USERNAME;


# Load some useful functions
include 'defaults/openstack/functions';

# Load Barbican-related type definitions
include 'types/openstack/barbican';

# Include general openstack variables
include 'defaults/openstack/config';

# Include policy file if OS_BARBICAN_POLICY is defined
include 'components/filecopy/config';
'/software/components/filecopy/services' = openstack_load_policy('barbican', OS_BARBICAN_POLICY);


include 'features/barbican/rpms';


###################################
# Configuration file for Barbican #
###################################

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/barbican/barbican.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
# Restart memcached to ensure considtency with service configuration changes
'daemons/memcached' = 'restart';
bind '/software/components/metaconfig/services/{/etc/barbican/barbican.conf}/contents' = openstack_barbican_config;


# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/log_file' = 'barbican-api.log';
'contents/DEFAULT/host_href' = format(
    '%s://%s:%s',
    OS_BARBICAN_PROTOCOL,
    OS_BARBICAN_PUBLIC_HOST,
    if ( is_defined(OS_BARBICAN_PUBLIC_PORT) ) OS_BARBICAN_PUBLIC_PORT else OS_BARBICAN_CONTROLLER_PORT,
);
'contents/DEFAULT/log_dir' = '/var/log/barbican';
'contents/DEFAULT/rpc_response_timeout' = 120;
'contents/DEFAULT/sql_connection' = format(
    'mysql+pymysql://%s:%s@%s/barbican',
    OS_BARBICAN_DB_USERNAME,
    OS_BARBICAN_DB_PASSWORD,
    OS_BARBICAN_DB_HOST,
);
'contents/DEFAULT/wsgi_default_pool_size' = OS_BARBICAN_WSGI_POOL_SIZE;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_BARBICAN_USERNAME;
'contents/keystone_authtoken/password' = OS_BARBICAN_PASSWORD;

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');
'contents/oslo_messaging_rabbit/heartbeat_in_pthread' = false;
'contents/oslo_messaging_rabbit/kombu_missing_consumer_retry_timeout' = 120;

###################
# Configure uSWGI #
###################
include 'features/barbican/uwsgi/config';


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_BARBICAN_PROTOCOL == 'https' ) 'features/barbican/nginx/config';
