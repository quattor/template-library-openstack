unique template features/haproxy/config;

include 'features/haproxy/rpms/config';

include 'components/filecopy/config';
include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/haproxy.tt}';
'config' = file_contents('features/haproxy/metaconfig/haproxy.tt');
'perms' = '0644';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'daemons/haproxy' = 'restart';
'contents/global/logs/{/dev/log}' = list('local0','notice');
'contents/global/config/tune.ssl.default-dh-param' = 2048;
'contents/global/config/chroot' = '/var/lib/haproxy';
'contents/global/config/pidfile' = '/var/run/haproxy.pid';
'contents/global/config/maxconn' = 4000;
'contents/global/config/user' = 'haproxy';
'contents/global/config/group' = 'haproxy';
'contents/global/config/daemon' = '';
'contents/global/stats/socket' = '/var/lib/haproxy/stats';
'contents/stats/enabled' = '';
'contents/stats/hide-version' = '';
'contents/stats/refresh' = 5;
'contents/defaults/config/log' = 'global';
#'contents/defaults/config/mode' = 'dontlognull';
'contents/defaults/config/retries' = 3;
'contents/defaults/config/maxconn' = 4000;
'contents/defaults/timeouts/check' = 3500;
'contents/defaults/timeouts/queue' = 3500;
'contents/defaults/timeouts/connect' = 3500;
'contents/defaults/timeouts/client' = 10000;
'contents/defaults/timeouts/server' = 10000;

# Services
include 'components/chkconfig/config';
prefix "/software/components/chkconfig/service";

"haproxy/on" = "";
"haproxy/startstop" = true;
