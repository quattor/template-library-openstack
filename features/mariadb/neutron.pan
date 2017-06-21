unique template features/mariadb/neutron;

include 'components/mysql/config';
variable usersdict = if (OPENSTACK_HA) {
        users = dict();
        foreach(k;v;OPENSTACK_NEUTRON_SERVERS) {
                users[escape(OPENSTACK_NEUTRON_DB_USERNAME+"@"+k)]= dict(
                        'password',OPENSTACK_NEUTRON_DB_PASSWORD,
                        'rights',list('ALL PRIVILEGES'),
                )
        };
        users;
} else {
        dict(
                OPENSTACK_NEUTRON_DB_USERNAME, dict(
                        'password',OPENSTACK_NEUTRON_DB_PASSWORD,
                        'rights',list('ALL PRIVILEGES')
                )
        );
};
prefix '/software/components/mysql/databases';
'neutron' = {
    SELF['createDb'] = true;
    SELF['server'] = OPENSTACK_NEUTRON_DB_HOST;
    SELF['users'] = usersdict;
    SELF;
};
