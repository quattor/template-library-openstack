unique template features/neutron/agents/dhcp_agent;

include 'types/openstack/neutron_agents';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'neutron-dhcp-agent/startstop' = true;

include 'components/metaconfig/config';

# /etc/neutron/dhcp_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/dhcp_agent.ini}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
bind '/software/components/metaconfig/services/{/etc/neutron/dhcp_agent.ini}/contents' = openstack_neutron_dhcp_config;

# [DEFAULT] section
'contents/DEFAULT/interface_driver' = 'neutron.agent.linux.interface.BridgeInterfaceDriver';
'contents/DEFAULT/dhcp_driver' = 'neutron.agent.linux.dhcp.Dnsmasq';
'contents/DEFAULT/enable_isolated_metadata' = true;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT' = { if ( is_defined(OS_NEUTRON_DNSMASQ_CONFIG_PARAMS)) {
    SELF['dnsmasq_config_file'] = '/etc/neutron/dnsmasq-neutron.conf';
    SELF;
  } else {
    SELF;
  };
};
'contents/DEFAULT/dhcp_lease_duration' = OS_NEUTRON_DHCP_LEASE_DURATION;

# /etc/neutron/dnsmasq-neutron.conf
prefix '/software/components/metaconfig';
'services' = {if (is_defined(OS_NEUTRON_DNSMASQ_CONFIG_PARAMS)) {
    SELF[escape('/etc/neutron/dnsmasq-neutron.conf')] = dict(
      'module', 'tiny',
      'contents', dict('dhcp-option-force', OS_NEUTRON_DNSMASQ_CONFIG_PARAMS)
    );
    SELF;
  } else {
    SELF;
  };
};
