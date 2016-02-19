unique template features/memcache/config;

include 'features/memcache/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'memcached/on' = '';
'memcached/startstop' = true;
