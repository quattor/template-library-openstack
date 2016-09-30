unique template features/mariadb/glance;

include 'components/mysql/config';
variable usersdict = if (OPENSTACK_HA) {
    users = dict();
    foreach(k;v;OPENSTACK_GLANCE_SERVERS) {
        users[escape(OPENSTACK_GLANCE_DB_USERNAME+"@"+k)]= dict(
            'password',OPENSTACK_GLANCE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OPENSTACK_GLANCE_DB_USERNAME, dict(
            'password',OPENSTACK_GLANCE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'glance' = {
  SELF['createDb'] = true;
  SELF['server'] = OPENSTACK_GLANCE_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
