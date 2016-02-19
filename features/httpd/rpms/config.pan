unique template features/httpd/rpms/config;

prefix '/software/packages';
'httpd' ?= dict();
'mod_wsgi' ?= dict();
'{mod_ssl}' ?= {
  if ( OS_SSL ) {
    dict();
  } else {
    null;
  }
};