template defaults/openstack/haproxy;

include 'defaults/openstack/config';

include 'components/metaconfig/config';

@{Add to 1st arg list of vhosts Given name, port, servers return HAproxy vhost dict if there are any servers.
  optional 5th argument dict to set vhost attribute(s) (no merging).
}
function openstack_haproxy_vhost = {
    if (length(ARGV[3]) > 0) {
        vhost = dict(
            'name', ARGV[1],
            'port', ARGV[2],
            'bind', format('*:%d', ARGV[2]),
            'config', dict(
                'mode', 'http',
                'balance', 'source',
            ),
            'options', list('tcpka', 'httplog', 'ssl-hello-chk', 'httpchk'),
            'defaultoptions', dict(
                'inter', '2s',
                'downinter', '5s',
                'rise', 3,
                'fall', 2,
                'slowstart', '60s',
                'maxqueue', 128,
                'weight', 100,
            ),
            'servers', ARGV[3],
        );
        if (ARGC == 5) {
            foreach(k; v; ARGC[4]) {
                vhost[k] = v;
            };
        };

        # Uses SELF, should be HAproxy vhosts attribute
        append(ARGV[0], vhost);
    };
};

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts' = {
    vhosts = list();
    # Nova
    openstack_haproxy_vhost(vhosts, 'nova-osapi', OPENSTACK_NOVA_OSAPI_PORT, OPENSTACK_NOVA_SERVERS);
    openstack_haproxy_vhost(vhosts, 'nova-ec2', OPENSTACK_NOVA_EC2_PORT, OPENSTACK_NOVA_SERVERS);

    openstack_haproxy_vhost(vhosts, 'nova-metadata', OPENSTACK_NOVA_METADATA_PORT, OPENSTACK_NOVA_SERVERS);
    openstack_haproxy_vhost(vhosts, 'nova-novnc', OPENSTACK_NOVA_NOVNC_PORT, OPENSTACK_NOVA_SERVERS, dict(
        'config', dict(
            'mode', 'tcp',
            'balance', 'source',
            ),
        'options', list('tcpka', 'tcplog'),
    ));

    # Neutron
    openstack_haproxy_vhost(vhosts, 'neutron', OPENSTACK_NEUTRON_PORT, OPENSTACK_NEUTRON_SERVERS);
    openstack_haproxy_vhost(vhosts, 'neutron-metadata', OPENSTACK_NEUTRON_METADATA_PORT, OPENSTACK_NEUTRON_SERVERS);

    # Keystone
    openstack_haproxy_vhost(vhosts, 'keystone', OPENSTACK_KEYSTONE_PORT, OPENSTACK_KEYSTONE_SERVERS);
    openstack_haproxy_vhost(vhosts, 'keystone-admin', OPENSTACK_KEYSTONE_ADMIN_PORT, OPENSTACK_KEYSTONE_SERVERS);

    # Cinder
    openstack_haproxy_vhost(vhosts, 'cinder', OPENSTACK_CINDER_PORT, OPENSTACK_CINDER_SERVERS);

    # Glance
    openstack_haproxy_vhost(vhosts, 'glance', OPENSTACK_GLANCE_PORT, OPENSTACK_GLANCE_SERVERS);

    # Horizon
    openstack_haproxy_vhost(vhosts, 'horizon', OPENSTACK_HORIZON_PORT, OPENSTACK_HORIZON_SERVERS, dict(
        'config', dict(
            'mode', 'http',
            'balance', 'source',
            'capture', 'cookie vgnvisitor= len 32',
            'cookie', 'SERVERID insert indirect nocache',
            'rspidel', '^Set-cookie:\ IP=',
            ),
        'options', list('tcpka', 'httplog', 'httpchk', 'forwardfor'),
        'serveroptions', dict(
            'cookie', 'control',
            ),
    ));

    # Heat
    openstack_haproxy_vhost(vhosts, 'heat-cfn', OPENSTACK_HEAT_CFN_PORT, OPENSTACK_HEAT_SERVERS);
    openstack_haproxy_vhost(vhosts, 'heat', OPENSTACK_HEAT_PORT, OPENSTACK_HEAT_SERVERS);

    # Ceilometer
    openstack_haproxy_vhost(vhosts, 'ceilometer', OPENSTACK_CEILOMETER_PORT, OPENSTACK_CEILOMETER_SERVERS);

    merge(SELF, vhosts);
};
