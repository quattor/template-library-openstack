unique template features/mariadb/nova;

include 'components/mysql/config';
variable usersdict = if (OPENSTACK_HA) {
    users = dict();
    foreach(k;v;OPENSTACK_NOVA_SERVERS) {
        users[escape(OPENSTACK_NOVA_DB_USERNAME+"@"+k)]= dict(
            'password',OPENSTACK_NOVA_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OPENSTACK_NOVA_DB_USERNAME, dict(
            'password',OPENSTACK_NOVA_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'nova' = {
  SELF['createDb'] = true;
  SELF['server'] = OPENSTACK_NOVA_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
'nova_api' = {
  SELF['createDb'] = true;
  SELF['server'] = OPENSTACK_NOVA_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
