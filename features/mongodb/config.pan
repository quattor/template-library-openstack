template features/mongodb/config;

include 'features/mongodb/rpms/config';

include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'path', OS_MONGODB_DBPATH,
    'owner', 'mongod:root',
    'type', 'd',
    'perm', '0755',
  );
  SELF;
};

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'mongod/on' = '';
'mongod/startstop' = true;

# Configuration file for MongoDB
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/mongod.conf}';
'module' = 'yaml';
'daemons/mongod' = 'restart';
'contents/net/bindIp' = '127.0.0.1,' + PRIMARY_IP;
'contents/storage/dbPath' = OS_MONGODB_DBPATH;
'contents/systemLog/path' = '/var/log/mongodb/mongod.log';
'contents/systemLog/destination' = 'file';
'contents/systemLog/logAppend' = 'true';
'contents/processManagement/fork' = 'true';
'contents/processManagement/pidFilePath' = '/var/run/mongodb/mongod.pid';
'contents/storage/journal/enabled' = 'true';
