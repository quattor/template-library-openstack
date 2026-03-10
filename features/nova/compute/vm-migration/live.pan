unique template features/nova/compute/vm-migration/live;

@{
desc = live migration mode
values = choice of normal, auto-convergence or post-copy
default = normal
required = no
}
variable OS_NOVA_LIVE_MIGRATION_MODE ?= 'normal';

final variable OS_NOVA_LIVE_MIGRATION_VALID_MODS = list('auto-convergence', 'normal', 'post-copy');
variable OS_NOVA_LIVE_MIGRATION_MODE =
if ( index(OS_NOVA_LIVE_MIGRATION_MODE, OS_NOVA_LIVE_MIGRATION_VALID_MODS) < 0 ) {
    error(
        "OS_NOVA_LIVE_MIGRATION_MODE invalid value(%s). Valid values = %s",
        OS_NOVA_LIVE_MIGRATION_MODE,
        to_string(OS_NOVA_LIVE_MIGRATION_VALID_MODS),
    );
} else {
    SELF;
};

# Add and enable libvirt-daemon-proxy
include 'components/systemd/config';
'/software/packages' = pkg_repl('libvirt-daemon-proxy');
'/software/components/systemd/unit' = {
    unit_prefix = 'virtproxyd';
    SELF[unit_prefix] = dict(
        'startstop', false,
        'state', 'enabled',
    );
    foreach (j; socket; list('admin', 'ro', 'tcp')) {
        SELF[format('%s-%s', unit_prefix, socket)] = dict(
            'startstop', true,
            'type', 'socket',
        );
    };
    SELF;
};

# Define libvirt configuration
include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/libvirt/virtproxyd.conf}';
# The mataconfig libvirtd module defines that libvirtd daemon must be restarted when the file changes
# but it doesn't exist anymore on EL9 (modular daemons are started by socket units)
'module' = 'tiny';
'backup' = '.old';
'convert/doublequote' = true;
bind '/software/components/metaconfig/services/{/etc/libvirt/virtproxyd.conf}/contents' = openstack_nova_libvirt_proxyd;
'contents/listen_tls' = false;
'contents/listen_tcp' = true;
'contents/auth_tcp' = 'none';

# Enable auto-convergence or post-copy, if requested
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'contents/libvirt' = {
    if ( OS_NOVA_LIVE_MIGRATION_MODE == 'auto-convergence' ) {
        SELF['live_migration_permit_auto_converge'] = true;
        SELF['live_migration_permit_post_copy'] = false;
    } else if ( OS_NOVA_LIVE_MIGRATION_MODE == 'post-copy' ) {
        SELF['live_migration_permit_auto_converge'] = false;
        SELF['live_migration_permit_post_copy'] = true;
    } else {
        SELF['live_migration_permit_auto_converge'] = false;
        SELF['live_migration_permit_post_copy'] = false;
    };

    SELF;
};
