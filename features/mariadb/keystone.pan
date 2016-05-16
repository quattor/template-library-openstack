unique template features/mariadb/keystone;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_KEYSTONE_SERVERS) {
        users[escape(OS_KEYSTONE_DB_USERNAME+"@"+k)]= dict(
            'password',OS_KEYSTONE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_KEYSTONE_DB_USERNAME, dict(
            'password',OS_KEYSTONE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'keystone' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_KEYSTONE_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
