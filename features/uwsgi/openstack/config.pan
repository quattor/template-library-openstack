unique template features/uwsgi/openstack/config;

variable OS_UWSGI_BIN ?= '/usr/sbin/uwsgi';

# Add RPM
'/software/packages' = pkg_repl('uwsgi-plugin-python3');

# Create a systemd service for uwsgi
include 'components/systemd/config';
'/software/components/systemd/skip/service' = false;

'/software/components/systemd/unit/{uwsgi}/file/replace' = true;
'/software/components/systemd/unit/{uwsgi}/startstop' = true;

prefix '/software/components/systemd/unit/{uwsgi}/file/config/unit';
'Description' = 'uSWGI service';
'After' = list('syslog.target', 'network.target');

prefix '/software/components/systemd/unit/{uwsgi}/file/config/install';
'WantedBy' = list('multi-user.target');

prefix '/software/components/systemd/unit/{uwsgi}/file/config/service';
'ExecStart' = format("%s --ini /etc/uwsgi.ini", OS_UWSGI_BIN);
'KillSignal' = 'SIGQUIT';
'NotifyAccess' = 'all';
'PrivateTmp' = true;
'Restart' = 'on-failure';
'SyslogIdentifier' = 'uwsgi';
