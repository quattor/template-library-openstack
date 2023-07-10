unique template features/nova/compute/ceph;

variable OS_LIBVIRT_CEPH_SECRET ?= error("OS_LIBVIRT_CEPH_SECRET must be defined with the Ceph key for client.cinder Ceph user");
# Note : OS_LIBVIRT_CEPH_SECRET_UUID must match what is defined in the RBD backend of the Cinder configuration
# as Cinder passes the UUID to use to Nova compute service. Currently, there is no support in the templates
# for configuring multiple secrets corresponding to different Cinder backends.
variable OS_LIBVIRT_CEPH_SECRET_UUID ?= error("OS_LIBVIRT_CEPH_SECRET_UUID must be defined with the libvirt UUID for the client.cinder key");

final variable OS_LIBVIRT_SECRET_XML_FMT = <<EOF;
<secret ephemeral='no' private='no'>
<uuid>%s</uuid>
<usage type='ceph'>
<name>client.cinder secret</name>
</usage>
</secret>
EOF

final variable OS_LIBVIRT_ADD_SECRET_FMT  = <<EOF;
#!/bin/sh
virsh secret-define --file %s
virsh secret-set-value --secret %s --base64 %s
EOF

final variable OS_LIBVIRT_ADD_SECRET_BIN = '/var/run/quattor/add_secret';
final variable OS_LIBVIRT_SECRET_XML_FILE = '/var/run/quattor/secret.xml';


include 'components/filecopy/config';
'/software/components/filecopy/services' ={
    SELF[escape(OS_LIBVIRT_SECRET_XML_FILE)] = dict(
        'config', format(OS_LIBVIRT_SECRET_XML_FMT, OS_LIBVIRT_CEPH_SECRET_UUID),
        'owner', 'root:root',
        'perms', '0600',
        'restart', OS_LIBVIRT_ADD_SECRET_BIN,
    );

    SELF[escape(OS_LIBVIRT_ADD_SECRET_BIN)] = dict(
        'config', format(OS_LIBVIRT_ADD_SECRET_FMT, OS_LIBVIRT_SECRET_XML_FILE, OS_LIBVIRT_CEPH_SECRET_UUID, OS_LIBVIRT_CEPH_SECRET),
        'owner', 'root:root',
        'perms', '0700',
        'restart', OS_LIBVIRT_ADD_SECRET_BIN,
    );

    SELF;
};
