template features/mongodb/openstack/config;

include 'defaults/openstack/config';

include 'features/mongodb/openstack/schema';

include 'features/mongodb/openstack/rpms';

# If using a non standard DB location, create the directory
include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
    if ( is_defined(OS_MONGODB_DBPATH) ) {
        SELF[length(SELF)] = dict(
            'path', OS_MONGODB_DBPATH,
            'owner', 'mongod:mongod',
            'type', 'd',
            'perm', '0755',
        );
    };
  SELF;
};

# Enable service
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'mongod/startstop' = true;

# Configuration file for MongoDB
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/mongod.conf}';
'module' = 'tiny';
'convert/joincomma' = true;
'convert/truefalse' = true;
'daemons/mongod' = 'restart';
bind '/software/components/metaconfig/services/{/etc/mongod.conf}/contents' = openstack_mongodb_config;
'contents/bind_ip' = list('127.0.0.1', PRIMARY_IP);
'contents/dbpath' = if ( is_defined(OS_MONGODB_DBPATH) ) {
    OS_MONGODB_DBPATH
} else {
    null;
};
'contents/fork' = true;
'contents/journal' = true;
