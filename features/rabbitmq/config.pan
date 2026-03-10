unique template features/rabbitmq/config;

include 'features/rabbitmq/rpms/config';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'rabbitmq-server/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/rabbitmq/rabbitmq.conf}';
'module' = 'tiny';
'convert/truefalse' = true;
'daemons/rabbitmq-server' = 'restart';

'contents/heartbeat' = 120;
'contents/tcp_listen_options.backlog' = 4096;
'contents/tcp_listen_options.nodelay' = true;
'contents/tcp_listen_options.linger.on' = true;
'contents/tcp_listen_options.linger.timeout' = 0;
'contents/tcp_listen_options.exit_on_close' = false;


# /var/run/rabbitmq is not created by RPMs
include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
    SELF[length(SELF)] = dict(
        'path', '/var/run/rabbitmq',
        'owner', 'rabbitmq:rabbitmq',
        'type', 'd',
        'perm', '0755',
    );
    SELF;
};
