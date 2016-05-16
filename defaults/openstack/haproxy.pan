template defaults/openstack/haproxy;

include 'defaults/openstack/config';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/usr/local/bin/haproxy-reload}';
'module' = 'haproxy-reload';
'contents/ports' =append(list(OS_NOVA_OSAPI_PORT));

########
# Nova #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'nova-osapi',
    'port' , OS_NOVA_OSAPI_PORT,
    'bind' ,  '*:'+to_string(OS_NOVA_OSAPI_PORT),
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
    'servers', OS_NOVA_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'nova-ec2',
    'port' , OS_NOVA_EC2_PORT,
    'bind' ,  '*:'+to_string(OS_NOVA_EC2_PORT),
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
    'servers', OS_NOVA_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'nova-metadata',
    'port' , OS_NOVA_METADATA_PORT,
    'bind' ,  '*:'+to_string(OS_NOVA_METADATA_PORT),
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
    'servers', OS_NOVA_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'nova-novnc',
    'port' , OS_NOVA_NOVNC_PORT,
    'bind' ,  '*:'+to_string(OS_NOVA_NOVNC_PORT),
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
    'servers', OS_NOVA_SERVERS,)
);

########
# Neutron #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'neutron',
    'port' , OS_NEUTRON_PORT,
    'bind' ,  '*:'+to_string(OS_NEUTRON_PORT),
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
    'servers', OS_NEUTRON_SERVERS,)
);

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'neutron-metadata',
    'port' , OS_NEUTRON_METADATA_PORT,
    'bind' ,  '*:'+to_string(OS_NEUTRON_METADATA_PORT),
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
    'servers', OS_NEUTRON_SERVERS,)
);


########
# Keystone #
########


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'keystone',
    'port' , OS_KEYSTONE_PORT,
    'bind' ,  '*:'+to_string(OS_KEYSTONE_PORT),
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
    'servers', OS_KEYSTONE_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'keystone-admin',
    'port' , OS_KEYSTONE_ADMIN_PORT,
    'bind' , '*:'+to_string(OS_KEYSTONE_ADMIN_PORT),
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
    'servers', OS_KEYSTONE_SERVERS,)
);


########
# Cinder #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'cinder',
    'port' , OS_CINDER_PORT,
    'bind' ,  '*:'+to_string(OS_CINDER_PORT),
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
    'servers', OS_CINDER_SERVERS,)
);

########
# Glance #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'glance',
    'port' , OS_GLANCE_PORT,
    'bind' ,  '*:'+to_string(OS_GLANCE_PORT),
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
    'servers', OS_GLANCE_SERVERS,)
);


########
# Horizon #
########

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'horizon',
    'port' , OS_HORIZON_PORT,
    'bind' , '*:'+to_string(OS_HORIZON_PORT),
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
    'servers', OS_HORIZON_SERVERS,)
);

########
# Heat #
########


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'heat-cfn',
    'port' , OS_HEAT_CFN_PORT,
    'bind' ,  '*:'+to_string(OS_HEAT_CFN_PORT),
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
    'servers', OS_HEAT_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'heat',
    'port' , OS_HEAT_PORT,
    'bind' , '*:'+to_string(OS_HEAT_PORT),
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
    'servers', OS_HEAT_SERVERS,)
);

########
# Ceilometer #
########


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'ceilometer',
    'port' , OS_CEILOMETER_PORT,
    'bind' ,  '*:'+to_string(OS_CEILOMETER_PORT),
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
    'servers', OS_CEILOMETER_SERVERS,)
);
