unique template features/mariadb/neutron;

include 'components/mysql/config';
include 'features/mariadb/functions';

'/software/components/mysql/databases/neutron' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_NEUTRON_DB_HOST;
    SELF['users'] = mariadb_openstack_addusers(OPENSTACK_NEUTRON_SERVERS,
        OPENSTACK_NEUTRON_DB_USERNAME, OPENSTACK_NEUTRON_DB_PASSWORD);
    SELF;
};
