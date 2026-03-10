unique template features/pci-passthrough/compute/config;

variable PCI_IDS = dict('vendor', '10de', 'product', '2231', 'name', 'rtxA5000');

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';
'pci/device_spec' = format(
    '{ "vendor_id": "%s", "product_id": "%s" }',
    PCI_IDS['vendor'],
    PCI_IDS['product'],
);
'pci/alias' = format(
    '{ "vendor_id": "%s", "product_id": "%s", "name": "%s" }',
    PCI_IDS['vendor'],
    PCI_IDS['product'],
    PCI_IDS['name'],
);

include 'components/grub/config';

prefix '/software/components/grub';
'args' = 'intel_iommu=on';

include 'components/modprobe/config';
prefix '/software/components/modprobe';
'modules' = {
    SELF[length(SELF)] = dict(
        'name', 'vfio-pci',
        'options', format('ids=%s:%s', PCI_IDS['vendor'], PCI_IDS['product']),
    );
    SELF[length(SELF)] = dict('name', 'snd_hda_intel', 'blacklist', 'snd_hda_intel');
    SELF;
};
