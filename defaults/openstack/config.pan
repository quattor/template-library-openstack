unique template defaults/openstack/config;

# This file defines a set of global variables for configuring the 
# OpenStack middleware.  Where the variables have sensible defaults,
# real values are given.  Others which must be changed are defined
# as 'undef'.  These will generate errors if you use them without
# redefining the value. 

# This template should be included after any of your customizations
# but before using any of the standard OpenStack templates in your
# machine definitions.

# Default architecture
variable PKG_ARCH_DEFAULT ?= 'x86_64';

# Define the root locations of the MW software trees. These
# are used in many configuration files and for setting the ld.so.conf 
# libraries.  You do not redefine these unless you install the OpenStack
# middleware in non-standard locations. 

# Installation root for the software.  Most of the OpenStack packages
# install by default in /. 

variable OPENSTACK_LOCATION ?= '/';
variable OPENSTACK_LOCATION_ETC ?= '/etc';
variable OPENSTACK_LOCATION_LOG ?= '/var/log';
variable OPENSTACK_LOCATION_VAR ?= '/var';
variable OPENSTACK_LOCATION_TMP ?= '/tmp';

#----------------------------------------------------------------
# SECURITY LOCATIONS
#----------------------------------------------------------------

# Constants used for security-related files and directories.  Change these
# only if you keep these in non-standard locations.

variable SITE_DEF_GRIDSEC_ROOT ?= "/etc/grid-security";
variable SITE_DEF_HOST_CERT    ?= SITE_DEF_GRIDSEC_ROOT+"/hostcert.pem";
variable SITE_DEF_HOST_KEY     ?= SITE_DEF_GRIDSEC_ROOT+"/hostkey.pem";
variable SITE_DEF_GRIDMAP      ?= SITE_DEF_GRIDSEC_ROOT+"/grid-mapfile";
variable SITE_DEF_GRIDMAPDIR   ?= SITE_DEF_GRIDSEC_ROOT+"/gridmapdir";
variable SITE_DEF_CERTDIR      ?= SITE_DEF_GRIDSEC_ROOT+"/certificates";
variable SITE_DEF_VOMSDIR      ?= SITE_DEF_GRIDSEC_ROOT+"/vomsdir";

#----------------------------------------------------------------
# SITE DEFINITIONS
#----------------------------------------------------------------

# Site's DNS domain name.  This must be a fully-qualified domain
# name as a string.  It is used throughout the standard configuration.

variable SITE_DOMAIN ?= undef;

variable REGION_NAME ?= 'regionOne';
variable NEUTRON_REGION_NAME ?= REGION_NAME;


#----------------------------------------------------------------
# SERVICE LOCATIONS
#----------------------------------------------------------------

# Nova host (cloud controller) 
variable NOVA_PUBLIC_HOST ?= undef;
variable NOVA_INTERNAL_HOST ?= NOVA_PUBLIC_HOST;

# Keystone
variable KEYSTONE_PUBLIC_HOST ?= NOVA_PUBLIC_HOST;
variable KEYSTONE_INTERNAL_HOST ?= NOVA_INTERNAL_HOST;

# Cinder host
variable CINDER_PUBLIC_HOST ?= NOVA_PUBLIC_HOST;
variable CINDER_INTERNAL_HOST ?= NOVA_INTERNAL_HOST;

# Glance host
variable GLANCE_PUBLIC_HOST ?= NOVA_PUBLIC_HOST;
variable GLANCE_INTERNAL_HOST ?= NOVA_INTERNAL_HOST;

# Neutron host
variable NEUTRON_PUBLIC_HOST ?= NOVA_PUBLIC_HOST;
variable NEUTRON_INTERNAL_HOST ?= NOVA_INTERNAL_HOST;

# Rabbit host
variable RABBIT_HOST ?= NOVA_INTERNAL_HOST;

# MySQL host
variable MYSQL_HOST ?= NOVA_INTERNAL_HOST;

# Default endpoints
variable KEYSTONE_PROTOCOL ?= 'http';
variable KEYSTONE_PUBLIC_ENDPOINT ?= KEYSTONE_PROTOCOL + '://' + KEYSTONE_PUBLIC_HOST + ':5000/v2.0';
variable KEYSTONE_INTERNAL_ENDPOINT ?= KEYSTONE_PROTOCOL + '://' + KEYSTONE_INTERNAL_HOST + ':5000/v2.0';
