structure template features/rabbitmq/client/openstack;

'transport_url' = if (OPENSTACK_HA) {
    connection_string = '';

    foreach (rabbitmq_host; rabbitmq_port; OPENSTACK_RABBITMQ_HOSTS) {
        rabbitmq_connection = dict(
            'dbprotocol', 'rabbit',
            'dbuser', OPENSTACK_RABBITMQ_USERNAME,
            'dbpassword', OPENSTACK_RABBITMQ_PASSWORD,
            'dbhost', rabbitmq_host,
            'dbport', rabbitmq_port,
            'dbname', '');

        if (connection_string != '') {
            connection_string = format(
                '%s,%s',
                connection_string,
                openstack_dict_to_connection_string(rabbitmq_connection)
            );
        } else {
            connection_string = format(
                '%s',
                openstack_dict_to_connection_string(rabbitmq_connection)
            );
        };
        connection_string;

    }

};
