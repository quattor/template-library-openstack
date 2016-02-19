template features/mongodb/config;

include 'features/mongodb/rpms/config';

include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'path', OS_MONGODB_DBPATH,
    'owner', 'mongodb:root',
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
'module' = 'tiny';
'daemons/mongod' = 'restart';
'contents/bind_ip' = '127.0.0.1 ' + PRIMARY_IP;
'contents/dbpath' = OS_MONGODB_DBPATH;
'contents/logpath' = '/var/log/mongodb/mongod.log';
'contents/fork' = 'true';
'contents/journal' = 'true';
