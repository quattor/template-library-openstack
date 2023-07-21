unique template features/httpd/openstack/ssl/config;

@{
desc = Cipher suites enabled
values = list of strings (valid Cipher names)
default = see schema
required = no
}
variable OS_HTTPD_SSL_CIPHER_SUITES ?= null;

@{
desc = SSL protocols enabled
values = list of strings (valid protocol or -protocol to disable it)
default = see schema
required = no
}
variable OS_HTTPD_SSL_PROTOCOLS_ENABLED ?= null;


include 'features/httpd/openstack/ssl/schema';

prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/00-ssl-defaults.conf}';
'module' = 'openstack/httpd-ssl-defaults.tt';
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/httpd/conf.d/00-ssl-defaults.conf}/contents' = openstack_httpd_ssl_defaults;

'contents/SSLCipherSuite' = OS_HTTPD_SSL_CIPHER_SUITES;
'contents/SSLHonorCipherOrder' = false;
'contents/SSLProtocol' = OS_HTTPD_SSL_PROTOCOLS_ENABLED;
'contents/SSLSessionTickets' = false;
'contents/SSLUseStapling' = true;


# Load TT file to configure SSL defaults
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/httpd-ssl-defaults.tt}';
'config' = file_contents('features/httpd/openstack/ssl/ssl-defaults.tt');
'perms' = '0644';
