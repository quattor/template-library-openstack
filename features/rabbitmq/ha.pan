unique template features/rabbitmq/ha;

variable OPENSTACK_RABBITMQ_HOSTS_STRING = openstack_dict_to_hostport_string(OPENSTACK_RABBITMQ_HOSTS);

include 'components/filecopy/config';

prefix '/software/components/filecopy/services/{/etc/rabbitmq.config}';
'config' = format(file_contents('features/rabbitmq/files/rabbitmq.config'), OPENSTACK_RABBITMQ_HOSTS_STRING);
'restart' = 'systemctl restart rabbitmq-server.service';

prefix '/software/components/filecopy/services/{/var/lib/rabbitmq/.erlang.cookie}';
'config' = OPENSTACK_RABBITMQ_CLUSTER_SECRET;
'owner' = 'rabbitmq:rabbitmq';
'perms' = '0400';
'restart' = 'systemctl restart rabbitmq-server.service';
