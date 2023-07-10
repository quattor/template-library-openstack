# Ensure that OpenStack users/groups are preserved
unique template features/openstack/accounts;

final variable OS_PRESERVED_USERS = list(
    'ceilometer',
    'cinder',
    'glance',
    'heat',
    'keystone',
    'memcached',
    'mongodb',
    'neutron',
    'nova',
    'rabbitmq',
);
final variable OS_PRESERVED_GROUPS = OS_PRESERVED_USERS;

include 'components/accounts/config';

'/software/components/accounts/kept_users' = {
    foreach (i; user; OS_PRESERVED_USERS) {
        if ( ! is_defined(SELF[user]) ) {
            SELF[user] = '';
        };
    };

    SELF;
};

'/software/components/accounts/kept_groups' = {
    foreach (i; group; OS_PRESERVED_GROUPS) {
        if ( ! is_defined(SELF[group]) ) {
            SELF[group] = '';
        };
    };

    SELF;
};

