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
'contents/DEFAULT' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/DEFAULT/username' = OS_NEUTRON_USERNAME;
'contents/DEFAULT/password' = OS_NEUTRON_PASSWORD;
'contents/DEFAULT/auth_regions' = OS_REGION_NAME;
'contents/DEFAULT/nova_metadata_ip' = OS_METADATA_HOST;
'contents/DEFAULT/metadata_proxy_shared_secret' = OS_METADATA_SECRET;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
