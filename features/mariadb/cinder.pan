unique template features/mariadb/cinder;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/cinder' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_CINDER_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_CINDER_SERVERS,
        OPENSTACK_CINDER_DB_USERNAME, OPENSTACK_CINDER_DB_PASSWORD);
    SELF;
};
