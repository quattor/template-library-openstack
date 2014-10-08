template personality/nova/compute/config; 

variable NOVA_SERVICES ?= list('openstack-nova-compute');

# include configuration common to client and server
include { 'personality/nova/config' };


#------------------------------------------------------------------------------
# Setup libvirtd
#------------------------------------------------------------------------------

include { 'components/libvirtd/config' };

"/software/components/chkconfig/service/libvirtd/on" = ""; 
"/software/components/chkconfig/service/libvirtd/startstop" = true; 


#------------------------------------------------------------------------------
# Define several sysctl variables for the networking
#------------------------------------------------------------------------------

include { 'components/sysctl/config' };

'/software/components/sysctl/variables/net.ipv4.conf.all.rp_filter' = '0';
'/software/components/sysctl/variables/net.ipv4.conf.default.rp_filter' = '0';


#------------------------------------------------------------------------------
# Setup messagebus
#------------------------------------------------------------------------------

include { 'features/messagebus/config' };
