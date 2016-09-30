template features/mongodb/mongodb2;

# Configuration file for MongoDB
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/mongod.conf}';
'module' = 'tiny';
'daemons/mongod' = 'restart';
'contents/bind_ip' = '127.0.0.1, ' + PRIMARY_IP;
'contents/dbpath' = OPENSTACK_MONGODB_DBPATH;
'contents/logpath' = '/var/log/mongodb/mongod.log';
'contents/fork' = 'true';
'contents/journal' = 'true';
