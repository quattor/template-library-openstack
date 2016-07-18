unique template defaults/openstack/utils;

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/openstack/env.tt}';
'config' = file_contents('defaults/openstack/metaconfig/env.tt');

# Create Admin environment script
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/root/admin-openrc.sh}';
'module' = 'openstack/env';
'contents/variables/OS_PROJECT_DOMAIN_ID' = 'default';
'contents/variables/OS_USER_DOMAIN_ID' = 'default';
'contents/variables/OS_PROJECT_NAME' = 'admin';
'contents/variables/OS_TENANT_NAME' = 'admin';
'contents/variables/OS_USERNAME' = OS_USERNAME;
'contents/variables/OS_PASSWORD' = OS_PASSWORD;
'contents/variables/OS_AUTH_URL' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357/v3';
'contents/variables/OS_IDENTITY_API_VERSION' = 3;

include 'components/filecopy/config';
# Copy scripts to help with init scripts
prefix '/software/components/filecopy/services';
'{/usr/local/bin/quattor_openstack_add_domain.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_domain.sh'),
);
'{/usr/local/bin/quattor_openstack_add_endpoint.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_endpoint.sh'),
);
'{/usr/local/bin/quattor_openstack_add_user.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_user.sh'),
);
'{/usr/local/bin/quattor_openstack_add_role.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_role.sh'),
);
'{/usr/local/bin/quattor_openstack_add_user_role.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_user_role.sh'),
);
'{/usr/local/bin/quattor_openstack_add_service.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_service.sh'),
);
'{/usr/local/bin/quattor_openstack_add_project.sh}' = dict(
    'perms' ,'755',
    'config', file_contents('defaults/openstack/scripts/quattor_openstack_add_project.sh'),
);


# Create a initialization script

variable CONTENTS_INIT_SCRIPT = {
  if (OS_NEUTRON_DEFAULT) {
    file_contents('defaults/openstack/init.sh') + file_contents('defaults/openstack/init-network.sh');
  } else {
    file_contents('defaults/openstack/init.sh');
  };
};

variable OS_INIT_SCRIPT_GENERAL = format(
    file_contents('defaults/openstack/init-general.sh'),
    OS_REGION_NAME,
    OS_ADMIN_TOKEN,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_USERNAME,
    OS_PASSWORD,
);
