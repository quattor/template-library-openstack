unique template features/mariadb/config;

include 'features/mariadb/rpms/config';

include 'defaults/openstack/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'mariadb/on' = '';
'mariadb/startstop' = true;

include 'components/mysql/config';
prefix '/software/components/mysql';
'servers' = {
    # Keystone server configuration
    SELF[OPENSTACK_KEYSTONE_DB_HOST]['adminpwd'] = OPENSTACK_DB_ADMIN_PASSWORD;
    SELF[OPENSTACK_KEYSTONE_DB_HOST]['adminuser'] = OPENSTACK_DB_ADMIN_USERNAME;

    # Glance server configuration
    SELF[OPENSTACK_GLANCE_DB_HOST]['adminpwd'] = OPENSTACK_DB_ADMIN_PASSWORD;
    SELF[OPENSTACK_GLANCE_DB_HOST]['adminuser'] = OPENSTACK_DB_ADMIN_USERNAME;

    # Nova server configuration
    SELF[OPENSTACK_NOVA_DB_HOST]['adminpwd'] = OPENSTACK_DB_ADMIN_PASSWORD;
    SELF[OPENSTACK_NOVA_DB_HOST]['adminuser'] = OPENSTACK_DB_ADMIN_USERNAME;

    # Neutron server configuration
    SELF[OPENSTACK_NEUTRON_DB_HOST]['adminpwd'] = OPENSTACK_DB_ADMIN_PASSWORD;
    SELF[OPENSTACK_NEUTRON_DB_HOST]['adminuser'] = OPENSTACK_DB_ADMIN_USERNAME;
    SELF;

    # Cinder server configuration
    SELF[OPENSTACK_CINDER_DB_HOST]['adminpwd'] = OPENSTACK_DB_ADMIN_PASSWORD;
    SELF[OPENSTACK_CINDER_DB_HOST]['adminuser'] = OPENSTACK_DB_ADMIN_USERNAME;
    SELF;

    # Heat server configuration
    SELF[OPENSTACK_HEAT_DB_HOST]['adminpwd'] = OPENSTACK_DB_ADMIN_PASSWORD;
    SELF[OPENSTACK_HEAT_DB_HOST]['adminuser'] = OPENSTACK_DB_ADMIN_USERNAME;
    SELF;
};
'serviceName' = 'mariadb';

# Configure each database
include 'features/mariadb/keystone';
include 'features/mariadb/glance';
include 'features/mariadb/neutron';
include 'features/mariadb/nova';
include {
    if (OPENSTACK_CINDER_ENABLED) {
        'features/mariadb/cinder';
    } else {
        null;
    };
};

include {
    if (OPENSTACK_HEAT_ENABLED) {
        'features/mariadb/heat';
    } else {
        null;
    };
};

include {
    if (OPENSTACK_AODH_ENABLED) {
        'features/mariadb/aodh';
    } else {
        null;
    };
};
