unique template features/accounts/config;

########################
# Keep Openstack Users #
########################

include 'components/accounts/config';
prefix '/software/components/accounts';

# Nova user
'kept_users/nova' = '';
'kept_groups/nova' = '';

# Glance user
'kept_users/glance' = '';
'kept_groups/glance' = '';

# Keystone user
'kept_users/keystone' = '';
'kept_groups/keystone' = '';

# Neutron user
'kept_users/neutron' = '';
'kept_groups/neutron' = '';

# Cinder user
'kept_users/cinder' = '';
'kept_groups/cinder' = '';

# Ceilometer user
'kept_users/ceilometer' = '';
'kept_groups/ceilometer' = '';

# Heat user
'kept_users/heat' = '';
'kept_groups/heat' = '';


# Rabbitmq user
'kept_users/rabbitmq' = '';
'kept_groups/rabbitmq' = '';

# Memcached user
'kept_users/memcached' = '';
'kept_groups/memcached' = '';

# MongoDB user
'kept_users/mongodb' = '';
'kept_groups/mongodb' = '';
