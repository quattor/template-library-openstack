unique template features/memcache/config;

include 'features/memcache/rpms/config';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'memcached/startstop' = true;
