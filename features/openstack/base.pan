structure template features/openstack/base;

'auth_strategy' = 'keystone';
'transport_url' = format('rabbit://%s:%s@%s//', OS_RABBITMQ_USERNAME, OS_RABBITMQ_PASSWORD, OS_RABBITMQ_HOST);
