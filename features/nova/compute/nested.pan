unique template features/nova/compute/nested;

include 'components/modprobe/config';

prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}/contents';
'libvirt/cpu_mode' = 'host-passthrough';

"/software/components/modprobe/modules" = push(nlist("name","kvm_intel","options","nested=1"));
"/software/components/modprobe/modules" = push(nlist("name","kvm_amd","options","nested=1"));
"/software/components/modprobe/file" = "/etc/modprobe.d/kvm.conf";
