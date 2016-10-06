template features/mongodb/config;

include 'features/mongodb/rpms/mongodb' + to_string(OS_MONGODB_VERSION);

include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'path', OS_MONGODB_DBPATH,
    'owner', format('%s:root', OS_MONGODB_USER),
    'type', 'd',
    'perm', '0755',
  );
  SELF;
};

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'mongod/on' = '';
'mongod/startstop' = true;

include 'features/mongodb/mongodb' + to_string(OS_MONGODB_VERSION);
