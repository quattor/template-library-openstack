unique template features/nova/compute/vm-migration/cold;

@{
desc = filecontaining the nova SSH private key
values = file path (relative to pan include path)
default = site/openstack/vm-migration/nova_ssh.key
required = no
}
variable OS_NOVA_SSH_PRIVATE_KEY ?= 'site/openstack/vm-migration/nova_ssh.key';


###################################################
# Configuration common to cold and live migration #
###################################################

variable OS_NOVA_ACCOUNT_GROUPS = list('nova', 'nobody');
# Merge with previous line until it has been checked that this template is not required on a Nova server
variable OS_NOVA_ACCOUNT_GROUPS = if ( OS_NODE_TYPE == "compute" ) append("qemu") else SELF;
variable OS_NOVA_ACCOUNT_GROUPS = if ( OS_NODE_TYPE == "compute" ) append("libvirt") else SELF;

# To allow cold migration to work, we need to set /bin/bash as the nova user shell
# and to update the nova user groups
include 'components/accounts/config';
prefix '/software/components/accounts/users';
'nova/shell' = '/bin/bash';
'nova/uid' = 162;
'nova/groups' = OS_NOVA_ACCOUNT_GROUPS;
'nova/homeDir' = '/var/lib/nova';
'nova/comment' = 'OpenStack Nova Daemons';

# Put public key into nova account
include 'components/useraccess/config';
prefix '/software/components/useraccess/users';
'nova/ssh_keys_urls' = list('http://quattorsrv.lal.in2p3.fr/sshkeys/nova.pub');

# Deploy nova account private key
include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/var/lib/nova/.ssh/id_rsa}';
'owner' = 'nova:nova';
'perms' = '0600';
'config' = file_contents(OS_NOVA_SSH_PRIVATE_KEY);

# Define SSH client configuration to ignore host key check
include 'components/metaconfig/config';
include 'metaconfig/ssh/schema';
prefix '/software/components/metaconfig/services/{/var/lib/nova/.ssh/config}';
'module' = 'ssh/client';
bind '/software/components/metaconfig/services/{/var/lib/nova/.ssh/config}/contents' = ssh_config_file;

prefix '/software/components/metaconfig/services/{/var/lib/nova/.ssh/config}/contents';
'Host/0/hostnames' = list('*');
'Host/0/ConnectTimeout' = 10;
'Host/0/StrictHostKeyChecking' = 'no';
