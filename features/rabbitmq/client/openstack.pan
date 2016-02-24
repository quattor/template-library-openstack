structure template features/rabbitmq/client/openstack;

'rabbit_host' = if (!OS_HA) {OS_RABBITMQ_HOST;} else {null;};
'rabbit_hosts' = if (OS_HA) {hosts = '';
foreach(k;v;OS_RABBITMQ_HOSTS) {
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
'rabbit_userid' = OS_RABBITMQ_USERNAME;
'rabbit_password' = OS_RABBITMQ_PASSWORD;
