unique template features/mariadb/glance;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/glance' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_GLANCE_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_GLANCE_SERVERS,
        OPENSTACK_GLANCE_DB_USERNAME, OPENSTACK_GLANCE_DB_PASSWORD);
    SELF;
};
