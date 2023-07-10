unique template features/cinder/backend/config;

variable OS_CINDER_BACKEND_PARAMS ?= error('OS_CINDER_BACKEND_PARAMS is required when using multiple backends');


################################################
# Helper variables for easier processing later #
################################################

variable OS_CINDER_BACKEND_LIST = {
    backends = list();
    foreach (name; params; OS_CINDER_BACKEND_PARAMS) {
        if ( !is_defined(params['type']) ) {
           error("missing 'type' attribute for backend %s", name);
        };
    backends[length(backends)] = name;
    };
    backends;
};
variable OS_CINDER_CEPH_BACKEND_PRESENT = {
    foreach (name; params; OS_CINDER_BACKEND_PARAMS) {
        if ( params['type'] == 'rbd' ) return (true);
    };
    false;
};
variable OS_CINDER_LVM_BACKEND_PRESENT = {
    lvm_backends = list();
    foreach (name; params; OS_CINDER_BACKEND_PARAMS) {
        if ( params['type'] == 'lvm' ) return (true);
    };
    false;
};


########################################
# Configuration common to all backends #
########################################

prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}/contents/';

# [ DEFAULT] section
'DEFAULT/enabled_backends' = OS_CINDER_BACKEND_LIST;

# [backend_defaults] section
'backend_defaults/rbd_exclusive_cinder_pool' = false;
'backend_defaults/rados_connect_timeout' = -1;
'backend_defaults/target_protocol' = 'iscsi';
'backend_defaults/target_helper' = 'lioadm';


#################################################
# Backend-specific parameters and configuration #
#################################################

'/software/components/metaconfig/services/{/etc/cinder/cinder.conf}/contents' = {
    sections = SELF;
    ceph_section_found = false;
    foreach (name; params; OS_CINDER_BACKEND_PARAMS) {
        sections[name] = dict();

        # LVM Backend
        if ( params['type'] == 'lvm' ) {
            sections[name]['volume_driver'] = 'cinder.volume.drivers.lvm.LVMVolumeDriver';
            if ( is_defined(params['volume_group']) ) {
                sections[name]['volume_group'] = params['volume_group'];
            } else {
                error("backend %s: missing 'volume_group' attribute", name);
            };
            if ( is_defined(params['target_protocol']) ) {
                sections[name]['target_protocol'] = params['target_protocol'];
            };
            if ( is_defined(params['target_helper']) ) {
                sections[name]['target_helper'] = params['target_helper'];
            };

        # Ceph RBD backend
        } else if ( params['type'] == 'rbd' ) {
            if ( ceph_section_found ) {
                errror('Configuration of multiple Ceph backends is not currently supported');
            } else {
                ceph_section_found = true;
            };

            sections[name]['volume_driver'] = 'cinder.volume.drivers.rbd.RBDDriver';
            if ( is_defined(params['rbd_pool']) ) {
                sections[name]['rbd_pool'] = params['rbd_pool'];
            } else {
                error("backend %s: missing 'rbd_pool' attribute", name);
            };
            if ( is_defined(params['rbd_user']) ) {
                sections[name]['rbd_user'] = params['rbd_user'];
            } else {
                error("backend %s: missing 'rbd_user' attribute", name);
            };
            if ( is_defined(params['rbd_chunk_size']) ) {
                sections[name]['rbd_store_chunk_size'] = params['rbd_chunk_size'];
            };
            if ( is_defined(params['rbd_ceph_conf']) ) {
                sections[name]['rbd_ceph_conf'] = params['rbd_ceph_conf'];
            } else {
                sections[name]['rbd_ceph_conf'] = '/etc/ceph/ceph.conf';
            };
            if ( is_defined(params['rados_connect_timeout']) ) {
                sections[name]['rados_connect_timeout'] = params['rados_connect_timeout'];
            };
            if ( is_defined(params['rbd_exclusive_cinder_pool']) ) {
                sections[name]['rbd_exclusive_cinder_pool'] = params['rbd_exclusive_cinder_pool'];
            };
            # Ideally rbd_secret_uuid should be a backend parameter but this requires to configure
            # the compute accordingly. In the meantime, use a global variable to define the secret UUID
            # and restrict the number of Ceph backend to 1.
            if ( is_defined(params['rbd_secret_uuid']) ) {
                error("Defining rbd_secret_uuid per backend is currently not supported: use OS_LIBVIRT_CEPH_SECRET_UUID instead");
                sections[name]['rbd_secret_uuid'] = params['rbd_secret_uuid'];
            };
            sections[name]['rbd_secret_uuid'] = OS_LIBVIRT_CEPH_SECRET_UUID;

        # Unsupported backend
        } else {
            error('backend %s: %s is not a valid backend type', name, params['type']);
        };
    };
    sections;
};

# If one RBD backend is configured, add the required packages and the Ceph configuration for the cluster
include if ( OS_CINDER_CEPH_BACKEND_PRESENT ) 'features/cinder/backend/ceph';

# If the LVM backend is present, do the LVM configuration
include if ( OS_CINDER_LVM_BACKEND_PRESENT ) 'features/cinder/backend/lvm';
