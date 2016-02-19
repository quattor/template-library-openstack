unique template features/rabbitmq/config;

include 'features/rabbitmq/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'rabbitmq-server/on' = '';
'rabbitmq-server/startstop' = true;

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