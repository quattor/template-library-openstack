unique template features/cinder/backend/lvm;

# Install LVM package
'/software/packages' = pkg_repl('lvm');

# Configue LVM-related service
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'lvm2-lvmetad/startstop' = true;


