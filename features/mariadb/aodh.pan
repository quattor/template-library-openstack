unique template features/mariadb/aodh;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/aodh' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_AODH_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_AODH_SERVERS,
        OPENSTACK_AODH_DB_USERNAME, OPENSTACK_AODH_DB_PASSWORD);
    SELF;
};
