unique template features/mariadb/nova;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/nova' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_NOVA_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_NOVA_SERVERS,
        OPENSTACK_NOVA_DB_USERNAME, OPENSTACK_NOVA_DB_PASSWORD);
    SELF;
};
'nova_api' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_NOVA_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_NOVA_SERVERS,
        OPENSTACK_NOVA_DB_USERNAME, OPENSTACK_NOVA_DB_PASSWORD);
    SELF;
};
