unique template features/mariadb/keystone;

include 'components/mysql/config';
variable usersdict = if (OPENSTACK_HA) {
    users = dict();
    foreach(k;v;OPENSTACK_KEYSTONE_SERVERS) {
        users[escape(OPENSTACK_KEYSTONE_DB_USERNAME+"@"+k)]= dict(
            'password',OPENSTACK_KEYSTONE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OPENSTACK_KEYSTONE_DB_USERNAME, dict(
            'password',OPENSTACK_KEYSTONE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'keystone' = {
  SELF['createDb'] = true;
  SELF['server'] = OPENSTACK_KEYSTONE_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
