unique template features/magnum/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Magnum-related type definitions
include 'types/openstack/magnum';

# Include general openstack variables
include 'defaults/openstack/config';

include 'features/magnum/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'openstack-magnum-api/startstop' = true;
'openstack-magnum-conductor/startstop' = true;

# Configuration file for Magnum
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/magnum/magnum.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/openstack-magnum-api' = 'restart';
'daemons/openstack-magnum-conductor' = 'restart';
bind '/software/components/metaconfig/services/{/etc/magnum/magnum.conf}/contents' = openstack_magnum_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = openstack_load_ssl_config( OS_MAGNUM_PROTOCOL == 'https' );
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/log_file' = 'magnum.log';
'contents/DEFAULT/log_dir' = '/var/log/magnum';
'contents/DEFAULT/rpc_conn_pool_size' = OS_MAGNUM_RPC_CONN_POOL_SIZE;

# [api] section
'contents/api/host' = OS_MAGNUM_HOST;
'contents/api/port' = OS_MAGNUM_PORT;
'contents/api/enable_ssl' = OS_MAGNUM_PROTOCOL == 'https';
'contents/api' = openstack_load_ssl_config( OS_MAGNUM_PROTOCOL == 'https' );

# [certificates] section
'contents/certificates/cert_manager_type' = 'barbican';

# [cinder] section
'contents/cinder/default_docker_volume_type' = OS_MAGNUM_DEFAULT_VOLUME_TYPE;

# [cinder_client] section
'contents/cinder_client/region_name' = OS_REGION_NAME;

# [database] section
'contents/database/connection' = format('mysql+pymysql://%s:%s@%s/magnum', OS_MAGNUM_DB_USERNAME, OS_MAGNUM_DB_PASSWORD, OS_MAGNUM_DB_HOST);

# [heat_client] section
'contents/heat_client/region_name' = OS_HEAT_REGION_NAME;

# [keystone_auth] section
# Partial duplicate keystone_authtoken to work around a warning saying it is needed despite it seems 
# to work without it
'contents/keystone_auth' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_auth/password' = OS_MAGNUM_ADMIN_PASSWORD;
'contents/keystone_auth/username' = OS_MAGNUM_ADMIN_USERNAME;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/admin_user' = OS_MAGNUM_ADMIN_USERNAME;
'contents/keystone_authtoken/admin_password' = OS_MAGNUM_ADMIN_PASSWORD;
'contents/keystone_authtoken/admin_tenant_name' = OS_MAGNUM_ADMIN_TENANT;
'contents/keystone_authtoken/password' = OS_MAGNUM_ADMIN_PASSWORD;
'contents/keystone_authtoken/username' = OS_MAGNUM_ADMIN_USERNAME;

# [oslo_messaging_notifications] section
'contents/oslo_messaging_notifications' = openstack_load_config('features/oslo_messaging/notifications');

# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/openstack/client/base');

# [trust] section
'contents/trust/cluster_user_trust' = OS_MAGNUM_CLUSTER_USER_TRUST;
'contents/trust/trustee_domain_name' = 'magnum';
'contents/trust/trustee_domain_admin_name' = OS_MAGNUM_DOMAIN_ADMIN_USERNAME;
'contents/trust/trustee_domain_admin_password' = OS_MAGNUM_DOMAIN_ADMIN_PASSWORD;
'contents/trust/trustee_keysone_interface' = 'public';
