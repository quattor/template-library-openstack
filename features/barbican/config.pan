unique template features/barbican/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Load Barbican-related type definitions
include 'types/openstack/barbican';

# Include general openstack variables
include 'defaults/openstack/config';

include 'features/barbican/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'httpd/startstop' = true;

###################################
# Configuration file for Barbican #
###################################

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/barbican/barbican.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/barbican/barbican.conf}/contents' = openstack_barbican_config;


# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/base');
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = openstack_load_ssl_config( OS_BARBICAN_PROTOCOL == 'https' );
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/log_file' = 'barbican-api.log';
'contents/DEFAULT/host_href' = format('%s://%s:%s', OS_BARBICAN_PROTOCOL, OS_BARBICAN_HOST, OS_BARBICAN_PORT);
'contents/DEFAULT/log_dir' = '/var/log/barbican';
'contents/DEFAULT/rpc_conn_pool_size' = 200;
'contents/DEFAULT/sql_connection' = format('mysql+pymysql://%s:%s@%s/barbican', OS_BARBICAN_DB_USERNAME, OS_BARBICAN_DB_PASSWORD, OS_BARBICAN_DB_HOST);

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/memcached_servers' = list('localhost:11211');
'contents/keystone_authtoken/username' = OS_BARBICAN_USERNAME;
'contents/keystone_authtoken/password' = OS_BARBICAN_PASSWORD;


# ############
# httpd conf #
# ############

prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/wsgi-barbican.conf}';
'module' = 'openstack/wsgi-barbican';
'daemons/httpd' = 'restart';
'contents/listen' = '9311';

'contents/vhosts/0/port' = 9311;
'contents/vhosts/0/processgroup' = 'barbican-api';
'contents/vhosts/0/script' = ' /usr/lib/python3.6/site-packages/barbican/api/app.wsgi';
'contents/vhosts/0/ssl' = openstack_load_ssl_config( OS_BARBICAN_PROTOCOL == 'https' );

# Load TT file to configure Barbican virtual host
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-barbican.tt}';
'config' = file_contents('features/barbican/metaconfig/wsgi-barbican.tt');
'perms' = '0644';
