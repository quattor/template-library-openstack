unique template features/nginx/openstack/config;


include 'features/nginx/openstack/rpms';

# Enable nginx service
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'nginx/startstop' = true;

# Load TT file to configure the proxy virtual hosts
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/nginx-proxy.tt}';
'config' = file_contents('features/nginx/openstack/proxy.tt');
'perms' = '0644';
