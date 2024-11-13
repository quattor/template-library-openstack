unique template features/nova/compute/rpms;

'/software/packages' = {
    pkg_repl('openstack-nova-compute');
    pkg_repl('sysfsutils');
    pkg_repl('libvirt-client');

    # Antelope: the 2 following RPMs are required for virtio support but are not explicit
    # dependencies of openstack-nova-compute
    pkg_repl('qemu-kvm-device-display-virtio-gpu.x86_64');
    pkg_repl('qemu-kvm-device-display-virtio-gpu-pci.x86_64');

    SELF;
};
