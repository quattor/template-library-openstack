template personality/nova/config; 

# ----------------------------------------------------------------------------
# Nova Configuration
# ----------------------------------------------------------------------------

variable NOVA_CONFIG ?= '/etc/nova/nova.conf';

variable NOVA_CONFIG_CONTENTS ?= file_contents('personality/nova/templates/nova.templ');

"/software/components/filecopy/services" = npush(
    escape(NOVA_CONFIG), nlist(
        "config",NOVA_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-nova restart",
    ),
);


# ----------------------------------------------------------------------------
# Startup Script
# ----------------------------------------------------------------------------

include { 'components/glitestartup/config' };

variable NOVA_STARTUP_FILE ?= '/etc/nova-services';
variable NOVA_INIT_SCRIPT ?= '/etc/rc.d/init.d/openstack-nova';

'/software/components/glitestartup/configFile' = NOVA_STARTUP_FILE;
'/software/components/glitestartup/initScript' = NOVA_INIT_SCRIPT;
'/software/components/glitestartup/scriptPaths' = list("/etc/init.d");
'/software/components/glitestartup/restartServices' = true;

'/software/components/glitestartup/services' = {
  if ( exists(SELF) && is_defined(SELF) ) {
    SELF;
  } else {
    nlist();
  };
};

'/software/components/glitestartup/services' = {  
  services = SELF;

  foreach (i;service;NOVA_SERVICES) {
    services = glitestartup_mod_service(service);
  };

  if ( is_defined(services) && (length(services) > 0) ) {
    services;
  } else {
    null;
  };
};

