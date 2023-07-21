unique template features/openldap/openstack/config;

include 'features/openldap/openstack/rpms';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'slapd/startstop' = true;

# Configure a very basic DB_CONFIG
include 'components/metaconfig/config';
include 'features/openldap/openstack/schema';
prefix '/software/components/metaconfig/services/{/var/lib/ldap/DB_CONFIG}';
'module' = 'general';
bind '/software/components/metaconfig/services/{/var/lib/ldap/DB_CONFIG}/contents' = openstack_openldap_config;

'contents/set_cachesize' = '0 268435456 1';
'contents/set_lg_regionmax' = 262144;
'contents/set_lg_bsize' = 2097152;
