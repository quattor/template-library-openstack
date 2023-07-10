unique template features/pci-passthrough/compute/config;

variable PCI_IDS = dict('vendor', '10de', 'product', '2204', 'name', 'rtx3090');

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';
'pci/passthrough_whitelist' = '{ "vendor_id": "' + PCI_IDS['vendor'] + '", "product_id": "' + PCI_IDS['product'] + '" }';
'pci/alias' = '{ "vendor_id": "' + PCI_IDS['vendor'] + '", "product_id": "' + PCI_IDS['product'] + '", "name": "' + PCI_IDS['name'] + '" }';

include 'components/grub/config';

prefix '/software/components/grub';
'args' = 'intel_iommu=on';

include 'components/modprobe/config';
prefix '/software/components/modprobe';
'modules' = {
  SELF[length(SELF)] = dict('name', 'vfio-pci', 'options', 'ids=' + PCI_IDS['vendor'] + ':' + PCI_IDS['product'] + '');
  SELF[length(SELF)] = dict('name', 'snd_hda_intel', 'blacklist', 'snd_hda_intel');
  SELF;
};
