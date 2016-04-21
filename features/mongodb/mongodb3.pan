template features/mongodb/mongodb3;

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
