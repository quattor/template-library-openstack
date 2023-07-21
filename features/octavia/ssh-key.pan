# This template creates the private and public key for the octavia account

unique template features/octavia/ssh-key;

@{
desc = file containing the octavia SSH private key
values = file path (relative to pan include path)
default = site/openstack/octavia/ssh.key
required = no
}
variable OS_OCTAVIA_SSH_PRIVATE_KEY_FILE ?= 'site/openstack/octavia/ssh_key';

@{
desc = file containing the octavia SSH public key
values = file path (relative to pan include path)
default = site/openstack/octavia/ssh_key.pub
required = no
}
variable OS_OCTAVIA_SSH_PUBLIC_KEY_FILE ?= 'site/openstack/octavia/ssh_key.pub';


# Deploy octavia account private key
include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/var/lib/octavia/.ssh/id_rsa}';
'owner' = 'octavia:octavia';
'perms' = '0600';
'config' = file_contents(OS_OCTAVIA_SSH_PRIVATE_KEY_FILE);

# Deploy octavia account public key
include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/var/lib/octavia/.ssh/id_rsa.pub}';
'owner' = 'octavia:octavia';
'perms' = '0644';
'config' = file_contents(OS_OCTAVIA_SSH_PUBLIC_KEY_FILE);


