unique template features/neutron/network/agents/dhcp_agent;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-dhcp-agent/on' = '';
'neutron-dhcp-agent/startstop' = true;

include 'components/metaconfig/config';

# /etc/neutron/dhcp_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/dhcp_agent.ini}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/interface_driver' = OPENSTACK_NEUTRON_INTERFACE_DRIVER;
'contents/DEFAULT/dhcp_driver' = 'neutron.agent.linux.dhcp.Dnsmasq';
'contents/DEFAULT/enable_isolated_metadata' = 'True';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OPENSTACK_LOGGING_TYPE);
'contents/DEFAULT' = { if ( is_defined(OPENSTACK_NEUTRON_DNSMASQ_CONFIG_PARAMS)) {
        SELF['dnsmasq_config_file'] = '/etc/neutron/dnsmasq-neutron.conf';
        SELF;
    } else {
        SELF;
    };
};

# /etc/neutron/dnsmasq-neutron.conf
prefix '/software/components/metaconfig';
'services' = {if (is_defined(OPENSTACK_NEUTRON_DNSMASQ_CONFIG_PARAMS)) {
        SELF[escape('/etc/neutron/dnsmasq-neutron.conf')] = dict(
            'module', 'tiny',
            'contents', dict('dhcp-option-force', OPENSTACK_NEUTRON_DNSMASQ_CONFIG_PARAMS)
        );
        SELF;
    } else {
        SELF;
    };
};
