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

'contents/ServerName' = openstack_get_controller_host(OPENSTACK_KEYSTONE_SERVERS);

prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/wsgi-keystone.conf}';
'module' = 'openstack/wsgi-keystone';
'daemons/httpd' = 'restart';
'contents/listen' = list(5000, 35357);

'contents/vhosts/0/port' = 5000;
'contents/vhosts/0/processgroup' = 'keystone-public';
'contents/vhosts/0/script' = '/usr/bin/keystone-wsgi-public';
'contents/vhosts/0/ssl' = if (OPENSTACK_SSL) {
    SELF['SSLEngine'] = 'on';
    SELF['SSLCertificateFile'] = OPENSTACK_SSL_CERT;
    SELF['SSLCertificateKeyFile'] = OPENSTACK_SSL_KEY;
    if (exists(OPENSTACK_SSL_CHAIN)) {
        SELF['SSLCertificateChainFile'] = OPENSTACK_SSL_CHAIN;
    };
    SELF;
} else {
    null;
};

'contents/vhosts/1/port' = 35357;
'contents/vhosts/1/processgroup' = 'keystone-admin';
'contents/vhosts/1/script' = '/usr/bin/keystone-wsgi-admin';
'contents/vhosts/1/ssl' = if (OPENSTACK_SSL) {
    SELF['SSLEngine'] = 'on';
    SELF['SSLCertificateFile'] = OPENSTACK_SSL_CERT;
    SELF['SSLCertificateKeyFile'] = OPENSTACK_SSL_KEY;
    if (exists(OPENSTACK_SSL_CHAIN)) {
        SELF['SSLCertificateChainFile'] = OPENSTACK_SSL_CHAIN;
    };
    SELF;
} else {
    null;
};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-keystone.tt}';
'config' = file_contents('features/httpd/metaconfig/wsgi-keystone.tt');
'perms' = '0644';
