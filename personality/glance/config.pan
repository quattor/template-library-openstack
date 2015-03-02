unique template personality/glance/config;

# User running Glance daemons (normally created by RPMs)
variable GLANCE_USER ?= 'glance';
variable GLANCE_GROUP ?= 'glance';

variable GLANCE_EMAIL ?= SITE_EMAIL;
variable GLANCE_KEYSTONE_TENANT ?= 'service';
variable GLANCE_KEYSTONE_USER ?= 'glance';
variable GLANCE_KEYSTONE_PASSWORD ?= error('GLANCE_KEYSTONE_PASSWORD required but not specified');
variable GLANCE_SERVICES ?= list('openstack-glance-api','openstack-glance-registry');

# Database related variables
variable GLANCE_MYSQL_ADMINUSER ?= 'root';
variable GLANCE_MYSQL_ADMINPWD ?= error('GLANCE_MYSQL_ADMINPWD required but not specified');
variable GLANCE_DB_NAME ?= 'glance';
variable GLANCE_DB_USER ?= 'glance';
variable GLANCE_DB_PASSWORD ?= error('GLANCE_DB_PASSWORD required but not specified');

variable GLANCE_SQL_CONNECTION ?= 'mysql://'+GLANCE_DB_USER+':'+GLANCE_DB_PASSWORD+'@'+GLANCE_MYSQL_SERVER+'/'+GLANCE_DB_NAME;


#------------------------------------------------------------------------------
# Glance configuration
#------------------------------------------------------------------------------

variable GLANCE_API_CONFIG ?= '/etc/glance/glance-api.conf';

variable GLANCE_API_CONFIG_CONTENTS ?= file_contents('personality/glance/templates/glance-api.templ');

variable GLANCE_API_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('RABBIT_USERID',RABBIT_USER,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('SQL_CONNECTION',GLANCE_SQL_CONNECTION,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('GLANCE_KEYSTONE_TENANT',GLANCE_KEYSTONE_TENANT,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('GLANCE_KEYSTONE_USER',GLANCE_KEYSTONE_USER,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('GLANCE_KEYSTONE_PASSWORD',GLANCE_KEYSTONE_PASSWORD,GLANCE_API_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_API_CONFIG), nlist(
        "config",GLANCE_API_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-api restart",
    ),
);

variable GLANCE_REGISTRY_CONFIG ?= '/etc/glance/glance-registry.conf';

variable GLANCE_REGISTRY_CONFIG_CONTENTS ?= file_contents('personality/glance/templates/glance-registry.templ');

variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('SQL_CONNECTION',GLANCE_SQL_CONNECTION,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('GLANCE_KEYSTONE_TENANT',GLANCE_KEYSTONE_TENANT,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('GLANCE_KEYSTONE_USER',GLANCE_KEYSTONE_USER,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('GLANCE_KEYSTONE_PASSWORD',GLANCE_KEYSTONE_PASSWORD,GLANCE_REGISTRY_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_REGISTRY_CONFIG), nlist(
        "config",GLANCE_REGISTRY_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-registry restart",
    ),
);


#------------------------------------------------------------------------------
# Glance Paste configuration
#------------------------------------------------------------------------------

variable GLANCE_API_PASTE ?= '/etc/glance/api-paste.ini';

variable GLANCE_API_PASTE_CONTENTS ?= file_contents('personality/glance/templates/glance-api-paste.templ');

variable GLANCE_API_PASTE_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('KEYSTONE_PROTOCOL',KEYSTONE_PROTOCOL,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_INTERNAL_ENDPOINT,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('GLANCE_KEYSTONE_TENANT',GLANCE_KEYSTONE_TENANT,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('GLANCE_KEYSTONE_USER',GLANCE_KEYSTONE_USER,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('GLANCE_KEYSTONE_PASSWORD',GLANCE_KEYSTONE_PASSWORD,GLANCE_API_PASTE_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_API_PASTE), nlist(
        "config",GLANCE_API_PASTE_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-api restart",
    ),
);

variable GLANCE_REGISTRY_PASTE ?= '/etc/glance/glance-registry-paste.ini';

variable GLANCE_REGISTRY_PASTE_CONTENTS ?= file_contents('personality/glance/templates/glance-registry-paste.templ');

variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('KEYSTONE_HOST',KEYSTONE_INTERNAL_HOST,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('KEYSTONE_PROTOCOL',KEYSTONE_PROTOCOL,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_INTERNAL_ENDPOINT,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('GLANCE_KEYSTONE_TENANT',GLANCE_KEYSTONE_TENANT,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('GLANCE_KEYSTONE_USER',GLANCE_KEYSTONE_USER,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('GLANCE_KEYSTONE_PASSWORD',GLANCE_KEYSTONE_PASSWORD,GLANCE_REGISTRY_PASTE_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_REGISTRY_PASTE), nlist(
        "config",GLANCE_REGISTRY_PASTE_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-registry restart",
    ),
);


#------------------------------------------------------------------------------
# MySQL configuration
#------------------------------------------------------------------------------

include { 'components/mysql/config' };

'/software/components/mysql/servers/' = {
    SELF[GLANCE_MYSQL_SERVER]['adminuser'] = GLANCE_MYSQL_ADMINUSER;
    SELF[GLANCE_MYSQL_SERVER]['adminpwd'] = GLANCE_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases/' = {
    SELF[GLANCE_DB_NAME]['server'] = GLANCE_MYSQL_SERVER;
    SELF[GLANCE_DB_NAME]['users'][GLANCE_DB_USER] = nlist(
        'password', GLANCE_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};


#------------------------------------------------------------------------------
# Endpoint configuration script
#------------------------------------------------------------------------------

variable GLANCE_ENDPOINTS ?= '/root/sbin/create-glance-endpoints.sh';
variable GLANCE_ENDPOINTS_CONTENTS ?= file_contents('personality/glance/templates/create-glance-endpoints.templ');

variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_KEYSTONE_PASSWORD',GLANCE_KEYSTONE_PASSWORD,GLANCE_ENDPOINTS_CONTENTS);
variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_EMAIL',GLANCE_EMAIL,GLANCE_ENDPOINTS_CONTENTS);
variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_PUBLIC_HOST',GLANCE_PUBLIC_HOST,GLANCE_ENDPOINTS_CONTENTS);
variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_HOST',GLANCE_INTERNAL_HOST,GLANCE_ENDPOINTS_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_ENDPOINTS), nlist(
        "config",GLANCE_ENDPOINTS_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;GLANCE_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};
