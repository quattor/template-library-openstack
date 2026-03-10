unique template features/httpd/openstack/config;

# Hack to prevent conflict with Nginx when used with Let's Encrypt/ACME
final variable OS_HTTPD_DISABLE_PORT_80 ?= true;

# Configure SSL defaults
final variable OS_HTTPD_CONFIGURE_SSL_DEFAULTS ?= false;

# RPMs must be added in the service using http with the function openstack_add_httpd_packages

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'httpd/startstop' = true;

# Configure SSL defaults
include if ( OS_HTTPD_CONFIGURE_SSL_DEFAULTS ) 'features/httpd/openstack/ssl/config';

# Overwrite default httpd configuration to disable port 80
include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    if ( OS_HTTPD_DISABLE_PORT_80 ) {
        SELF[escape('/etc/httpd/conf/httpd.conf')] = dict(
            'config', file_contents('features/httpd/openstack/httpd-port-80-disabled.conf'),
            'owner', 'root:root',
            'perms', '0644',
            'restart', 'systemctl restart httpd',
        );
    };
    SELF;
};
