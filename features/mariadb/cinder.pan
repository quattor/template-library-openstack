unique template features/mariadb/cinder;

include 'components/mysql/config';
prefix '/software/components/mysql/databases';
'cinder' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_CINDER_DB_HOST;
  SELF['users'][OS_CINDER_DB_USERNAME]['password'] = OS_CINDER_DB_PASSWORD;
  SELF['users'][OS_CINDER_DB_USERNAME]['rights'] = list('ALL PRIVILEGES');
  SELF;
};