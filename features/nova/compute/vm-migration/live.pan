unique template features/nova/compute/vm-migration/live;

@{
desc = live migration mode
values = choice of normal, auto-convergence or post-copy
default = normal
required = no
}
variable OS_NOVA_LIVE_MIGRATION_MODE ?= 'normal';

final variable OS_NOVA_LIVE_MIGRATION_VALID_MODS = list('auto-convergence', 'normal', 'post-copy');
variable OS_NOVA_LIVE_MIGRATION_MODE = if ( index(OS_NOVA_LIVE_MIGRATION_MODE, OS_NOVA_LIVE_MIGRATION_VALID_MODS) < 0 ) {
    error("OS_NOVA_LIVE_MIGRATION_MODE invalid value(%s). Valid values = %s", OS_NOVA_LIVE_MIGRATION_MODE, to_string(OS_NOVA_LIVE_MIGRATION_VALID_MODS));
} else {
    SELF;
};

# Define libvirt configuration
include 'components/metaconfig/config';

include 'metaconfig/libvirtd/config';
prefix '/software/components/metaconfig/services/{/etc/libvirt/libvirtd.conf}/contents';
'listen_tls' = false;
'listen_tcp' = true;
'auth_tcp' = 'none';

include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'libvirtd-tcp/startstop' = true;
'libvirtd-tcp/type' = 'socket';


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
