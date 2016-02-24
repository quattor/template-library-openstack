unique template features/mariadb/cinder;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_CINDER_SERVERS) {
        users[escape(OS_CINDER_DB_USERNAME+"@"+k)]= dict(
            'password',OS_CINDER_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_CINDER_DB_USERNAME, dict(
            'password',OS_CINDER_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'cinder' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_CINDER_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
