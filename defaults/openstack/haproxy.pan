template defaults/openstack/haproxy;

include 'defaults/openstack/config';

include 'components/metaconfig/config';

########
# Nova #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_NOVA_SERVERS) != 0) {dict('name' , 'nova-osapi',
    'port' , OPENSTACK_NOVA_OSAPI_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_NOVA_OSAPI_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',
    ),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_NOVA_SERVERS,)
    }
);
'contents/vhosts/' = append(if (length(OPENSTACK_NOVA_SERVERS) != 0) {dict('name' , 'nova-ec2',
    'port' , OPENSTACK_NOVA_EC2_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_NOVA_EC2_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_NOVA_SERVERS,)
    }
);
'contents/vhosts/' = append(if (length(OPENSTACK_NOVA_SERVERS) != 0) {dict('name' , 'nova-metadata',
    'port' , OPENSTACK_NOVA_METADATA_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_NOVA_METADATA_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_NOVA_SERVERS,)
    }
);
'contents/vhosts/' = append(if (length(OPENSTACK_NOVA_SERVERS) != 0) {dict('name' , 'nova-novnc',
    'port' , OPENSTACK_NOVA_NOVNC_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_NOVA_NOVNC_PORT),
    'config' , dict(
        'mode' , 'tcp',
        'balance' , 'source',),
    'options' , list('tcpka','tcplog'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_NOVA_SERVERS,)
    }
);

########
# Neutron #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_NEUTRON_SERVERS) != 0) {dict('name' , 'neutron',
    'port' , OPENSTACK_NEUTRON_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_NEUTRON_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_NEUTRON_SERVERS,)
    }
);

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_NEUTRON_SERVERS) != 0) {dict('name' , 'neutron-metadata',
    'port' , OPENSTACK_NEUTRON_METADATA_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_NEUTRON_METADATA_PORT),
    'config' , dict(
        'mode' , 'tcp',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','tcp-check'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_NEUTRON_SERVERS,)
    }
);


########
# Keystone #
########


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_KEYSTONE_SERVERS) != 0) {dict('name' , 'keystone',
    'port' , OPENSTACK_KEYSTONE_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_KEYSTONE_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_KEYSTONE_SERVERS,)
    }
);
'contents/vhosts/' = append(if (length(OPENSTACK_KEYSTONE_SERVERS) != 0) {dict('name' , 'keystone-admin',
    'port' , OPENSTACK_KEYSTONE_ADMIN_PORT,
    'bind' , '*:'+to_string(OPENSTACK_KEYSTONE_ADMIN_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_KEYSTONE_SERVERS,)
    }
);


########
# Cinder #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_CINDER_SERVERS) != 0) {dict('name' , 'cinder',
    'port' , OPENSTACK_CINDER_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_CINDER_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_CINDER_SERVERS,)
    }
);

########
# Glance #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_GLANCE_SERVERS) != 0) {dict('name' , 'glance',
    'port' , OPENSTACK_GLANCE_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_GLANCE_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_GLANCE_SERVERS,)
    }
);


########
# Horizon #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_HORIZON_SERVERS) != 0) {dict('name' , 'horizon',
    'port' , OPENSTACK_HORIZON_PORT,
    'bind' , '*:'+to_string(OPENSTACK_HORIZON_PORT),
    'config' , dict(
        'mode' , 'http',
        'capture','cookie vgnvisitor= len 32',
        'cookie', 'SERVERID insert indirect nocache',
        'rspidel', '^Set-cookie:\ IP=',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','httpchk','forwardfor','httpclose'),
    'defaultoptions',dict(
        'inter', 2,
        'downinter', 5,

        'rise', 3,
        'fall', 2,
        'slowstart', 60,
        'maxqueue', 128,
        'weight', 100,),
    'serveroptions',dict(
       'cookie','control',
    ),
    'servers', OPENSTACK_HORIZON_SERVERS,)
    }
);

########
# Heat #
########


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_HEAT_SERVERS) != 0) {dict('name' , 'heat-cfn',
    'port' , OPENSTACK_HEAT_CFN_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_HEAT_CFN_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_HEAT_SERVERS,)
    }
);
'contents/vhosts/' = append(if (length(OPENSTACK_HEAT_SERVERS) != 0) {dict('name' , 'heat',
    'port' , OPENSTACK_HEAT_PORT,
    'bind' , '*:'+to_string(OPENSTACK_HEAT_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','httpchk'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_HEAT_SERVERS,)
    }
);


########
# Ceilometer #
########


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(if (length(OPENSTACK_CEILOMETER_SERVERS) != 0) {dict('name' , 'ceilometer',
    'port' , OPENSTACK_CEILOMETER_PORT,
    'bind' ,  '*:'+to_string(OPENSTACK_CEILOMETER_PORT),
    'config' , dict(
        'mode' , 'http',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk','tcp-check'),
    'defaultoptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OPENSTACK_CEILOMETER_SERVERS,)
    }
);
