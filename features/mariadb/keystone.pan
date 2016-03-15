unique template features/mariadb/keystone;

include 'components/mysql/config';
prefix '/software/components/mysql/databases';
'keystone' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_KEYSTONE_DB_HOST;
  SELF['users'][OS_KEYSTONE_DB_USERNAME]['password'] = OS_KEYSTONE_DB_PASSWORD;
  SELF['users'][OS_KEYSTONE_DB_USERNAME]['rights'] = list('ALL PRIVILEGES');
  SELF;
};