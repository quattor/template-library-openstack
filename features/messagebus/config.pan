unique template features/messagebus/config;

#------------------------------------------------------------------------------
# Enable and start messagebus service
#------------------------------------------------------------------------------

include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/messagebus/on" = ""; 
"/software/components/chkconfig/service/messagebus/startstop" = true; 
