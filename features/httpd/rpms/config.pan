unique template features/httpd/rpms/config;

prefix '/software/packages';
'httpd' ?= dict();
'mod_wsgi' ?= dict();
'{mod_ssl}' ?= {
    if ( OPENSTACK_SSL ) {
        dict();
    } else {
        null;
    }
};