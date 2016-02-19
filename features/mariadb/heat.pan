unique template features/mariadb/heat;

include 'components/mysql/config';
prefix '/software/components/mysql/databases';
'heat' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_HEAT_DB_HOST;
  SELF['users'][OS_HEAT_DB_USERNAME]['password'] = OS_HEAT_DB_PASSWORD;
  SELF['users'][OS_HEAT_DB_USERNAME]['rights'] = list('ALL PRIVILEGES');
  SELF;
};
