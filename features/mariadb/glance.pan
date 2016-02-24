unique template features/mariadb/glance;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_GLANCE_SERVERS) {
        users[escape(OS_GLANCE_DB_USERNAME+"@"+k)]= dict(
            'password',OS_GLANCE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_GLANCE_DB_USERNAME, dict(
            'password',OS_GLANCE_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'glance' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_GLANCE_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
