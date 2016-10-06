template defaults/openstack/dicts;

variable OPENSTACK_GLANCE_DB ?= dict();
final variable OPENSTACK_GLANCE_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_GLANCE_DB_HOST,
    'dbname' , 'glance',
    'dbuser' , OPENSTACK_GLANCE_DB_USERNAME,
    'dbpassword' , OPENSTACK_GLANCE_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_HEAT_DB ?= dict();
final variable OPENSTACK_HEAT_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_HEAT_DB_HOST,
    'dbname' , 'heat',
    'dbuser' , OPENSTACK_HEAT_DB_USERNAME,
    'dbpassword' , OPENSTACK_HEAT_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_KEYSTONE_DB ?= dict();
final variable OPENSTACK_KEYSTONE_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_KEYSTONE_DB_HOST,
    'dbname' , 'keystone',
    'dbuser' , OPENSTACK_KEYSTONE_DB_USERNAME,
    'dbpassword' , OPENSTACK_KEYSTONE_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_NOVA_DB ?= dict();
final variable OPENSTACK_NOVA_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_NOVA_DB_HOST,
    'dbname' , 'nova',
    'dbuser' , OPENSTACK_NOVA_DB_USERNAME,
    'dbpassword' , OPENSTACK_NOVA_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_NOVA_API_DB ?= dict();
final variable OPENSTACK_NOVA_API_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_NOVA_DB_HOST,
    'dbname' , 'nova-api',
    'dbuser' , OPENSTACK_NOVA_DB_USERNAME,
    'dbpassword' , OPENSTACK_NOVA_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_NEUTRON_DB ?= dict();
final variable OPENSTACK_NEUTRON_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_NEUTRON_DB_HOST,
    'dbname' , 'neutron',
    'dbuser' , OPENSTACK_NEUTRON_DB_USERNAME,
    'dbpassword' , OPENSTACK_NEUTRON_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_CINDER_DB ?= dict();
final variable OPENSTACK_CINDER_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_CINDER_DB_HOST,
    'dbname' , 'cinder',
    'dbuser' , OPENSTACK_CINDER_DB_USERNAME,
    'dbpassword' , OPENSTACK_CINDER_DB_PASSWORD,
    'dbprotocol' , 'mysql',
    'dbport' , 3306,
));

variable OPENSTACK_CEILOMETER_DB ?= dict();
final variable OPENSTACK_CEILOMETER_DB = merge(SELF , dict(
    'dbhost' ,  OPENSTACK_CEILOMETER_DB_HOST,
    'dbname' , 'ceilometer',
    'dbuser' , OPENSTACK_CEILOMETER_DB_USERNAME,
    'dbpassword' , OPENSTACK_CEILOMETER_DB_PASSWORD,
    'dbprotocol' , 'mongodb',
    'dbport' , 27017,
));
