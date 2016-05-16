template features/mongodb/config;

include 'features/mongodb/rpms/mongodb' + to_string(OS_MONGODB_VERSION);

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

<<<<<<< HEAD

include 'features/mongodb/mongodb' + to_string(OS_MONGODB_VERSION);
=======
# Configuration file for MongoDB
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/mongod.conf}';
'module' = 'tiny';
'daemons/mongod' = 'restart';
'contents/bind_ip' =  if (OS_HA) {
    hosts = '';
    foreach(k;v;OS_CEILOMETER_SERVERS) {
        if ( hosts != '') {
            hosts = hosts + ' ' + v;
        } else {
            hosts = '127.0.0.1 ' + v;
        };
    };
    hosts;
} else {
    '127.0.0.1 ' + PRIMARY_IP;
};
'contents/dbpath' = OS_MONGODB_DBPATH;
'contents/logpath' = '/var/log/mongodb/mongod.log';
'contents/fork' = 'true';
'contents/journal' = 'true';
>>>>>>> origin/HA-Additions
