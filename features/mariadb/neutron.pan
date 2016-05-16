unique template features/mariadb/neutron;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_NEUTRON_SERVERS) {
        users[escape(OS_NEUTRON_DB_USERNAME+"@"+k)]= dict(
            'password',OS_NEUTRON_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_NEUTRON_DB_USERNAME, dict(
            'password',OS_NEUTRON_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'neutron' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_NEUTRON_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
