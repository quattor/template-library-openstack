unique template features/mariadb/heat;

include 'components/mysql/config';
variable usersdict = if (OPENSTACK_HA) {
    users = dict();
    foreach(k;v;OPENSTACK_HEAT_SERVERS) {
        users[escape(OPENSTACK_HEAT_DB_USERNAME+"@"+k)]= dict(
            'password',OPENSTACK_HEAT_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OPENSTACK_HEAT_DB_USERNAME, dict(
            'password',OPENSTACK_HEAT_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'heat' = {
  SELF['createDb'] = true;
  SELF['server'] = OPENSTACK_HEAT_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
