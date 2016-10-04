unique template features/mariadb/heat;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_HEAT_SERVERS) {
        users[escape(OS_HEAT_DB_USERNAME+"@"+k)]= dict(
            'password',OS_HEAT_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_HEAT_DB_USERNAME, dict(
            'password',OS_HEAT_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'heat' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_HEAT_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
