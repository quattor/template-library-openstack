structure template features/rabbitmq/client/openstack;

'rabbit_host' = if (!OPENSTACK_HA) {OPENSTACK_RABBITMQ_HOST;} else {null;};
'rabbit_hosts' = if (OPENSTACK_HA) {hosts = '';
foreach(k;v;OPENSTACK_RABBITMQ_HOSTS) {
        if ( hosts != '') {
            hosts = hosts +  "," + v + ":5672" ;
        } else {
            hosts = v + ":5672";
        };

        hosts;
    };
} else {
    null;
};
'rabbit_userid' = OPENSTACK_RABBITMQ_USERNAME;
'rabbit_password' = OPENSTACK_RABBITMQ_PASSWORD;
