unique template features/neutron/network/agents/metadata_agent;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-metadata-agent/on' = '';
'neutron-metadata-agent/startstop' = true;

include 'components/metaconfig/config';

# /etc/neutron/metadata_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/metadata_agent.ini}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config(OPENSTACK_AUTH_CLIENT_CONFIG);
'contents/DEFAULT/username' = OPENSTACK_NEUTRON_USERNAME;
'contents/DEFAULT/password' = OPENSTACK_NEUTRON_PASSWORD;
'contents/DEFAULT/auth_regions' = OPENSTACK_REGION_NAME;
'contents/DEFAULT/nova_metadata_ip' = OPENSTACK_METADATA_HOST;
'contents/DEFAULT/metadata_proxy_shared_secret' = OPENSTACK_METADATA_SECRET;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
