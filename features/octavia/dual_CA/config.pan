unique template features/octavia/dual_CA/config;

# Default should be appropriate
variable OS_OCTAVIA_PRIV_KEY_LENGH ?= 4096;
# Encryption algorithm must be a valide OpenSSL option and be supported by the schema
variable OS_OCTAVIA_PRIV_KEY_ENCRYPTION_ALG ?= 'aes-256-cbc';

include 'components/filecopy/config';
include 'components/metaconfig/config';
'/software/components/filecopy/dependencies/post' = openstack_add_component_dependency('metaconfig');


#############################
# Create CA creation script #
#############################

prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/create_dual_intermediate_CA.tt}';
'config' = file_contents('features/octavia/dual_CA/create_dual_intermediate_CA.sh.tt');
'perms' = '0644';

prefix '/software/components/metaconfig/services/{/root/octavia_ca/create_dual_intermediate_CA.sh}';
'module' = 'openstack/create_dual_intermediate_CA';
'convert/truefalse' = true;
'convert/joincomma' = true;
'mode' = 0700;
bind '/software/components/metaconfig/services/{/root/octavia_ca/create_dual_intermediate_CA.sh}/contents' = octavia_ca_parameters_config;
'contents/ca_cert_dir' = OS_OCTAVIA_CA_CERT_DIR;
'contents/priv_key_encryption_algorithm' = OS_OCTAVIA_PRIV_KEY_ENCRYPTION_ALG;
'contents/priv_key_length' = OS_OCTAVIA_PRIV_KEY_LENGH;

prefix '/software/components/filecopy/services/{/root/octavia_ca/priv_key_pwd}';
'config' = OS_OCTAVIA_CA_KEY_PASSWORD;
'perms' = '0400';


##################################################
# Create openssl.cnf used by the creation script #
##################################################

prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/openssl.cnf.tt}';
'config' = file_contents('features/octavia/dual_CA/openssl.cnf.tt');
'perms' = '0644';

prefix '/software/components/metaconfig/services/{/root/octavia_ca/openssl.cnf}';
'module' = 'openstack/openssl.cnf';
'convert/truefalse' = true;
'convert/joincomma' = true;
'mode' = 0600;
bind '/software/components/metaconfig/services/{/root/octavia_ca/openssl.cnf}/contents' = octavia_ca_parameters_config;
'contents' = value('/software/components/metaconfig/services/{/root/octavia_ca/create_dual_intermediate_CA.sh}/contents');


#############################################################
# Ensure that the directory for Octivia CA certs/keys exist #
#############################################################
include 'components/dirperm/config';
prefix '/software/components/dirperm';
'paths' = {
  SELF[length(SELF)] = dict(
    'path', OS_OCTAVIA_CA_CERT_DIR,
    'owner', 'octavia:octavia',
    'type', 'd',
    'perm', '0755',
  );
  SELF;
};
