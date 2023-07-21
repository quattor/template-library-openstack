unique template features/glance/store/file/nfs;

# NFS-related RPMs
'/software/packages' = {
    pkg_repl('autofs');
    pkg_repl('nfs-utils');
    pkg_repl('rpcbind');

    SELF;
};

# Start NFS-related services
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'autofs/startstop' = true;
'rpcbind/startstop' = true;

# Configure autofs
final variable OS_GLANCE_NFS_PARAMS = {
    params = split(';', OS_GLANCE_BACKEND_PARAMS[OS_GLANCE_FILE_BACKEND]['nfs_source']);
    if ( (length(params) == 0) || (length(params) > 3 ) ) {
        error(
            "OS_GLANCE_BACKEND_PARAMS nfs_source option must have between 1 and 3 semicolon-separated parameters. %s found (%s)",
            length(params),
            to_string(params),
        );
    }; 
    SELF['source'] = params[0];
    if ( length(params) >= 2 ) {
        mount_point = params[1];
    } else {
        mount_point = OS_GLANCE_BACKEND_PARAMS[OS_GLANCE_FILE_BACKEND]['directory'];
    };
    toks = matches(mount_point, '^(/.*)/(.*)$');
    if ( length(toks) == 3 ) {
        SELF['autofs_mount_point'] = toks[1];
        SELF['autofs_entry'] = toks[2];
    } else {
        error("%s is not a valid mount point for Glance image: a mount point directly under / is not currently supported", mount_point);
    };
    if ( length(params) >= 3 ) {
        SELF['options'] = params[2];
    } else {
        SELF['options'] = 'rw,noatime,hard';
    };

    SELF;
};
include 'components/autofs/config';
prefix '/software/components/autofs/maps/cloud';
'enabled' = true;
'mapname' = '/etc/auto.cloud';
'mountpoint' = OS_GLANCE_NFS_PARAMS['autofs_mount_point'];
'options'= OS_GLANCE_NFS_PARAMS['options'];
'preserve' = false;
'type' = 'file';
'entries' = {
    SELF[OS_GLANCE_NFS_PARAMS['autofs_entry']] = dict('location', OS_GLANCE_NFS_PARAMS['source']);
    SELF;
};
