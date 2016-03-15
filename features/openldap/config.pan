unique template features/openldap/config;

include 'features/openldap/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'slapd/on' = '';
'slapd/startstop' = true;

# Configure a very basic DB_CONFIG
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/var/lib/ldap/DB_CONFIG}';
'module' = 'general';

'contents/set_cachesize' = '0 268435456 1';
'contents/set_lg_regionmax' = '262144';
'contents/set_lg_bsize' = '2097152';