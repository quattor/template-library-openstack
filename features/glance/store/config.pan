unique template features/glance/store/config;

variable OS_GLANCE_BACKEND_PARAMS ?= error('OS_GLANCE_BACKEND_PARAMS is required when using multiple backends');
variable OS_GLANCE_BACKEND_DEFAULT ?= {
    if ( length(OS_GLANCE_BACKEND_PARAMS) > 1 ) {
        error('OS_GLANCE_BACKEND_DEFAULT is required when using multiple backends');
    } else {
      foreach (name; params; OS_GLANCE_BACKEND_PARAMS) {
          default_backend = name;
      };
      default_backend;
    };
};

# Helper variables for easier processing later
variable OS_GLANCE_BACKEND_LIST = {
    backends = list();
    foreach (name; params; OS_GLANCE_BACKEND_PARAMS) {
        if ( !is_defined(params['type']) ) {
           error("missing 'type' attribute for backend %s", name);
        };
    backends[length(backends)] = format("%s:%s", name, params['type']);
    };
    backends;
};
variable OS_GLANCE_CEPH_BACKEND_PRESENT = {
    foreach (name; params; OS_GLANCE_BACKEND_PARAMS) {
        if ( params['type'] == 'rbd' ) return (true);
    };
    false;
};
variable OS_GLANCE_FILE_BACKEND = {
    file_backends = list();
    foreach (name; params; OS_GLANCE_BACKEND_PARAMS) {
        if ( params['type'] == 'file' ) file_backends[length(file_backends)] = name;
    };
    if ( length(file_backends) == 0 ) {
        null;
    } else if ( length(file_backends) > 1 ) {
        error("Only one file backend is supported but multiple found (%s)", to_string(file_backends));
    } else {
        file_backends[0];
    };
};

prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}/contents/';
'DEFAULT/enabled_backends' = OS_GLANCE_BACKEND_LIST;
'DEFAULT/location_strategy' = if ( is_defined(OS_GLANCE_STORE_TYPE_PREFERENCE) ) {
    'store_type';
} else {
    null;
};


'glance_store/default_backend' = OS_GLANCE_BACKEND_DEFAULT;

'store_type_location_strategy' = {
    if ( is_defined(OS_GLANCE_STORE_TYPE_PREFERENCE) ) {
        SELF['store_type_preference'] = OS_GLANCE_STORE_TYPE_PREFERENCE;
    };

    if ( length(SELF) > 0 ) {
       SELF;
    } else {
       null;
    };
};

# Add backend-specific parameters
'/software/components/metaconfig/services/{/etc/glance/glance-api.conf}/contents' = {
    sections = SELF;
    foreach (name; params; OS_GLANCE_BACKEND_PARAMS) {
        sections[name] = dict();
        if ( is_defined(params['description']) ) {
            sections[name]['store_description'] = params['description'];
        };
        if ( params['type'] == 'file' ) {
            if ( is_defined(params['directory']) ) {
                sections[name]['filesystem_store_datadir'] = params['directory'];
            } else {
                error("backend %s: missing 'directory' attribute", name);
            };
        } else if ( params['type'] == 'rbd' ) {
            if ( is_defined(params['rbd_pool']) ) {
                sections[name]['rbd_store_pool'] = params['rbd_pool'];
            } else {
                error("backend %s: missing 'rbd_pool' attribute", name);
            };
            if ( is_defined(params['rbd_user']) ) {
                sections[name]['rbd_store_user'] = params['rbd_user'];
            } else {
                error("backend %s: missing 'rbd_user' attribute", name);
            };
            if ( is_defined(params['rbd_chunk_size']) ) {
                sections[name]['rbd_chunk_size'] = params['rbd_chunk_size'];
            } else {
                error("backend %s: missing 'rbd_chunk_size' attribute", name);
            };
            if ( is_defined(params['rbd_ceph_conf']) ) {
                sections[name]['rbd_store_ceph_conf'] = params['rbd_ceph_conf'];
            } else {
                sections[name]['rbd_store_ceph_conf'] = '/etc/ceph/ceph.conf';
            };
            if ( is_defined(params['rados_connect_timeout']) ) {
                sections[name]['rados_connect_timeout'] = params['rados_connect_timeout'];
            } else {
                sections[name]['rados_connect_timeout'] = 0;
            };
        } else if ( params['type'] == 'http') {
            # http has no specific options
            section[name] = dict()
        } else {
            error('backend %s: %s is not a valid backend type', name, params['type']);
        };
    };
    sections;
};

# If one RBD backend is configured, add the required packages and the Ceph configuration for the cluster
include if ( OS_GLANCE_CEPH_BACKEND_PRESENT ) 'features/glance/store/ceph';

# If the file backend is present, configure the image directory
include if ( ! is_null(OS_GLANCE_FILE_BACKEND) ) 'features/glance/store/file/config';
