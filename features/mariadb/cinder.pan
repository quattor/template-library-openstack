unique template features/mariadb/cinder;

include 'components/mysql/config';
variable usersdict = if (OPENSTACK_HA) {
    users = dict();
    foreach(k;v;OPENSTACK_CINDER_SERVERS) {
        users[escape(OPENSTACK_CINDER_DB_USERNAME+"@"+k)]= dict(
            'password',OPENSTACK_CINDER_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OPENSTACK_CINDER_DB_USERNAME, dict(
            'password',OPENSTACK_CINDER_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'cinder' = {
  SELF['createDb'] = true;
  SELF['server'] = OPENSTACK_CINDER_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
