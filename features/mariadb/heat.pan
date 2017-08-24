unique template features/mariadb/heat;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/heat' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_HEAT_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_HEAT_SERVERS,
        OPENSTACK_HEAT_DB_USERNAME, OPENSTACK_HEAT_DB_PASSWORD);
    SELF;
};
