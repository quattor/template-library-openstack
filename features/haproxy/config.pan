unique template features/haproxy/config;

include 'features/haproxy/rpms/config';

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/haproxy.tt}';
'config' = file_contents('features/haproxy/metaconfig/haproxy.tt');
'perms' = '0644';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'daemons/haproxy' = 'restart';

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}/contents';
'global/logs/{/dev/log}' = list('local0', 'notice');
'global/config/tune.ssl.default-dh-param' = 2048;
'global/config/chroot' = '/var/lib/haproxy';
'global/config/pidfile' = '/var/run/haproxy.pid';
'global/config/maxconn' = 4000;
'global/config/user' = 'haproxy';
'global/config/group' = 'haproxy';
'global/config/daemon' = '';
'global/stats/socket' = '/var/lib/haproxy/stats';

'stats/enabled' = '';
'stats/hide-version' = '';
'stats/refresh' = 5;

'defaults/config/log' = 'global';
#'defaults/config/mode' = 'dontlognull';
'defaults/config/retries' = 3;
'defaults/config/maxconn' = 4000;
'defaults/timeouts/check' = 3500;
'defaults/timeouts/queue' = 3500;
'defaults/timeouts/connect' = 3500;
'defaults/timeouts/client' = 10000;
'defaults/timeouts/server' = 10000;

# Services
include 'components/chkconfig/config';
prefix "/software/components/chkconfig/service";

"haproxy/on" = "";
"haproxy/startstop" = true;
