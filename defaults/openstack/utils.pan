unique template defaults/openstack/utils;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/env.tt}';
'config' = file_contents('defaults/openstack/metaconfig/env.tt');

# Create Admin environment script
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/root/admin-openrc.sh}';
'module' = 'env';
'contents/variables/OS_PROJECT_DOMAIN_ID' = 'default';
'contents/variables/OS_USER_DOMAIN_ID' = 'default';
'contents/variables/OS_PROJECT_NAME' = 'admin';
'contents/variables/OS_TENANT_NAME' = 'admin';
'contents/variables/OS_USERNAME' = OS_USERNAME;
'contents/variables/OS_PASSWORD' = OS_PASSWORD;
'contents/variables/OS_AUTH_URL' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357/v3';
'contents/variables/OS_IDENTITY_API_VERSION' = 3;

# Create a initialization script

variable CONTENTS_INIT_SCRIPT = {
  if (OS_NEUTRON_DEFAULT) {
    file_contents('defaults/openstack/init.sh') + file_contents('defaults/openstack/init-network.sh');
  } else {
    file_contents('defaults/openstack/init.sh');
  };
};
include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init.sh}' = dict(
  'perms' ,'755',
  'config', format(
    CONTENTS_INIT_SCRIPT,
    OS_RABBITMQ_USERNAME,
    OS_RABBITMQ_PASSWORD,
    OS_REGION_NAME,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_GLANCE_CONTROLLER_HOST,
    OS_NOVA_CONTROLLER_HOST,
    OS_NEUTRON_CONTROLLER_HOST,
    OS_HEAT_CONTROLLER_HOST,
    OS_HEAT_CONTROLLER_HOST,
    OS_CINDER_CONTROLLER_HOST,
    OS_CINDER_CONTROLLER_HOST,
    OS_CEILOMETER_CONTROLLER_HOST,
    OS_USERNAME,
    OS_PASSWORD,
    OS_GLANCE_USERNAME,
    OS_GLANCE_PASSWORD,
    OS_NOVA_USERNAME,
    OS_NOVA_PASSWORD,
    OS_NEUTRON_USERNAME,
    OS_NEUTRON_PASSWORD,
    OS_HEAT_USERNAME,
    OS_HEAT_PASSWORD,
    OS_HEAT_STACK_DOMAIN,
    OS_HEAT_DOMAIN_ADMIN_USERNAME,
    OS_HEAT_DOMAIN_ADMIN_PASSWORD,
    OS_CINDER_USERNAME,
    OS_CINDER_PASSWORD,
    OS_CEILOMETER_DB_HOST,
    OS_CEILOMETER_DB_USERNAME,
    OS_CEILOMETER_DB_PASSWORD,
    OS_CEILOMETER_USERNAME,
    OS_CEILOMETER_PASSWORD,
    OS_ADMIN_TOKEN,
    OS_NEUTRON_DEFAULT_NETWORKS,
    OS_NEUTRON_DEFAULT_DHCP_POOL['start'],
    OS_NEUTRON_DEFAULT_DHCP_POOL['end'],
    OS_NEUTRON_DEFAULT_GATEWAY,
    OS_NEUTRON_DEFAULT_NAMESERVER,
  ),
);
