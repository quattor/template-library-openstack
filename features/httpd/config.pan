unique template features/httpd/config;

include 'features/httpd/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'httpd/on' = '';
'httpd/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/01-servername.conf}';
'module' = 'general';
'daemons/httpd' = 'restart';

'contents/ServerName' = OS_KEYSTONE_CONTROLLER_HOST;

prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/wsgi-keystone.conf}';
'module' = 'apache-keystone';
'daemons/httpd' = 'restart';
'contents/listen' = list(5000, 35357);

'contents/vhosts/0/port' = 5000;
'contents/vhosts/0/processgroup' = 'keystone-public';
'contents/vhosts/0/script' = '/usr/bin/keystone-wsgi-public';
'contents/vhosts/0/ssl' = if (OS_SSL) {
  SELF['cert'] = OS_SSL_CERT;
  SELF['key'] = OS_SSL_KEY;
  if (exists(OS_SSL_CHAIN)) {
    SELF['chain'] = OS_SSL_CHAIN;
  };
  SELF;
} else {
  null;
};

'contents/vhosts/1/port' = 35357;
'contents/vhosts/1/processgroup' = 'keystone-admin';
'contents/vhosts/1/script' = '/usr/bin/keystone-wsgi-admin';
'contents/vhosts/1/ssl' = if (OS_SSL) {
  SELF['cert'] = '/etc/pki/tls/certs/localhost.crt';
  SELF['key'] = '/etc/pki/tls/private/localhost.key';
  SELF['chain'] = '/etc/pki/tls/certs/server-chain.crt';
  SELF;
} else {
  null;
};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/apache-keystone.tt}';
'config' = file_contents('features/httpd/metaconfig/apache-keystone.tt');
'perms' = '0644';
