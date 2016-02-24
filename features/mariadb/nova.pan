unique template features/mariadb/nova;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_NOVA_SERVERS) {
        users[escape(OS_NOVA_DB_USERNAME+"@"+k)]= dict(
            'password',OS_NOVA_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_NOVA_DB_USERNAME, dict(
            'password',OS_NOVA_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'nova' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_NOVA_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
