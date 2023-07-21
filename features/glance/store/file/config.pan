unique template features/glance/store/file/config;

# Create the image directory
include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'owner', 'glance:glance',
    'path', OS_GLANCE_BACKEND_PARAMS[OS_GLANCE_FILE_BACKEND]['directory'],
    'perm', '0755',
    'type', 'd',
  );
  SELF;
};

# Configure NFS if necessary
include if ( is_defined(OS_GLANCE_BACKEND_PARAMS[OS_GLANCE_FILE_BACKEND]['nfs_source']) ) 'features/glance/store/file/nfs';
