############################################################
#
# template machine-types/openstack/base
#
# Define base configuration of any type of OpenStack node.
# Can be included several times.
#
# RESPONSIBLE: Jerome Pansanel
#
############################################################

unique template machine-types/openstack/base;

# Include static information and derived global variables.
variable SITE_DB_TEMPLATE ?= 'site/databases';
include { SITE_DB_TEMPLATE };
variable SITE_GLOBAL_VARIABLES ?= 'site/global_variables';
include { SITE_GLOBAL_VARIABLES }; # Default value for net params

#
# define site functions
#
variable SITE_FUNCTIONS_TEMPLATE ?= if_exists('site/functions');
include { SITE_FUNCTIONS_TEMPLATE };

#
# profile_base for profile structure
#
include { 'quattor/profile_base' };

#
# NCM core components
#
include { 'components/spma/config' };
include { 'components/grub/config' };


#
# hardware
#
include { 'hardware/functions' };
"/hardware" = if ( exists(DB_MACHINE[escape(FULL_HOSTNAME)]) ) {
                  create(DB_MACHINE[escape(FULL_HOSTNAME)]);
              } else {
                  error(FULL_HOSTNAME + " : hardware not found in machine database");
              };
variable MACHINE_PARAMS_CONFIG ?= undef;
include { MACHINE_PARAMS_CONFIG };
"/hardware" = if ( exists(MACHINE_PARAMS) && is_nlist(MACHINE_PARAMS) ) {
                update_hw_params();
              } else {
                SELF;
              };


# Cluster specific configuration
variable CLUSTER_INFO_TEMPLATE ?= 'site/cluster_info';
include { CLUSTER_INFO_TEMPLATE };


# common site machine configuration
variable SITE_CONFIG_TEMPLATE ?= 'site/config';
include { SITE_CONFIG_TEMPLATE };


# File system configuration.
# pro_site_system_filesystems is legacy name and is used if present.
# filesystem/config is new generic approach for configuring file systems : use if it is present. It requires
# a site configuration template passed in FILESYSTEM_LAYOUT_CONFIG_SITE (same name as previous template
# but not the same contents).
variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= if_exists("site/filesystems/base");
variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= error("No file system layout template defined");
variable FILESYSTEM_CONFIG_SITE ?= 'filesystem/config';


# Define some other defaults if not defined in site/cluster configuration
variable OPENSTACK_BASE_CONFIG_SITE ?= null;
variable OPENSTACK_SITE_PARAMS ?= "site/openstack/config";


# Select OS version based on machine name
include { 'os/version' };


# Load gLite version information
include { 'defaults/openstack/version' };


# Define OS related namespaces
variable OS_NS_CONFIG = 'config/';
variable OS_NS_OS = OS_NS_CONFIG + 'core/';
variable OS_NS_QUATTOR = OS_NS_CONFIG + 'quattor/';
variable OS_NS_RPMLIST = 'rpms/';
variable OS_NS_REPOSITORY = 'repository/';


#
# software packages
#
include { 'pan/functions' };

#
# Configure Bind resolver
#
variable SITE_NAMED_CONFIG_TEMPLATE ?= 'site/named';
include { SITE_NAMED_CONFIG_TEMPLATE };


#
# Kernel version and CPU architecture
#
include { 'os/kernel_version_arch' };


#
# Default middleware architecture
#
variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;


#
# Include OS version dependent RPMs
#
include { if_exists(OS_NS_OS + "base") };


#
# Quattor client software
#
include { 'quattor/client/config' };


#
# Include site configuration for OpenStack software
#
include { return(OPENSTACK_SITE_PARAMS) };


#
# Include default OpenStack parameters (prevent absent variable in site
# parameter)
#

include { 'defaults/openstack/config' };


# Configure filesystem layout.
# Must be done after NFS initialisation as it may tweak some mount points.
include { return(FILESYSTEM_CONFIG_SITE) };


#
# AII component must be included after much of the other setup. 
#
include { OS_NS_QUATTOR + 'aii' };


# 
# Add local users if some configured
#
variable USER_CONFIG_INCLUDE = if ( exists(USER_CONFIG_SITE) && is_defined(USER_CONFIG_SITE) ) {
                                 return('users/config');
                               } else {
                                 return(null);
                               };
include { USER_CONFIG_INCLUDE };


#
# Add site specific configuration if any
#
include { return(OPENSTACK_BASE_CONFIG_SITE) };


#
# Setup SUDO
#

include { 'components/sudo/config' };

"/software/components/sudo/includes_dirs" = {
  push("/etc/sudoers.d");
};


# OPENSTACK_OS_POSTCONFIG defines a template that must be executed at the very
# end of any OpenStack machine type.
# The template is called by machine-types templates.
variable OPENSTACK_OS_POSTCONFIG ?= OS_NS_OS + 'postconfig';

# Default repository configuration template 
variable PKG_REPOSITORY_CONFIG ?= 'repository/config';
