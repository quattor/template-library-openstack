template features/mongodb/config;

include 'features/mongodb/rpms/mongodb' + to_string(OPENSTACK_MONGODB_VERSION);

include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
    SELF[length(SELF)] = dict(
        'path', OPENSTACK_MONGODB_DBPATH,
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

include 'features/mongodb/mongodb' + to_string(OPENSTACK_MONGODB_VERSION);
