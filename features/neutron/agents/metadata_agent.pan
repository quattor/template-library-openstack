unique template features/neutron/agents/metadata_agent;

include 'types/openstack/neutron_agents';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'neutron-metadata-agent/startstop' = true;

include 'components/metaconfig/config';

# /etc/neutron/metadata_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/metadata_agent.ini}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/neutron-metadata-agent' = 'restart';
bind '/software/components/metaconfig/services/{/etc/neutron/metadata_agent.ini}/contents' = openstack_neutron_metadata_config;

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/DEFAULT/username' = OS_NEUTRON_USERNAME;
'contents/DEFAULT/password' = OS_NEUTRON_PASSWORD;
'contents/DEFAULT/auth_regions' = OS_REGION_NAME;
'contents/DEFAULT/nova_metadata_host' = OS_NOVA_METADATA_HOST;
'contents/DEFAULT/metadata_proxy_shared_secret' = OS_METADATA_SECRET;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
