unique template features/rabbitmq/ha;

variable OS_RABBITMQ_HOSTS_STRING = { hosts = '';
foreach(k;v;OS_RABBITMQ_HOSTS) {
        if ( hosts != '') {
            hosts = hosts +  "," + "'" + v + "'" ;
        } else {
            hosts = "'" + v + "'";
        };

        hosts;
    };
};
prefix '/software/components/filecopy/services/{/etc/rabbitmq.config}';
'config' = format(file_contents('features/rabbitmq/files/rabbitmq.config'),OS_RABBITMQ_HOSTS_STRING);
'restart' = 'systemctl restart rabbitmq-server.service';

prefix '/software/components/filecopy/services/{/var/lib/rabbitmq/.erlang.cookie}';
'config' = OS_RABBITMQ_CLUSTER_SECRET;
'owner' = 'rabbitmq:rabbitmq';
'perms' = '0400';
'restart' = 'systemctl restart rabbitmq-server.service';
