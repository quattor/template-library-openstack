unique template features/httpd/openstack/config;

# RPMs must be added in the service using http with the function openstack_add_httpd_packages

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'httpd/startstop' = true;

# Configure SSL defaults
include 'features/httpd/openstack/ssl/config';
