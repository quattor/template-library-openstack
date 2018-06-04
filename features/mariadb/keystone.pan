unique template features/mariadb/keystone;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/keystone' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_KEYSTONE_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_KEYSTONE_SERVERS,
        OPENSTACK_KEYSTONE_DB_USERNAME, OPENSTACK_KEYSTONE_DB_PASSWORD);
    SELF;
};
