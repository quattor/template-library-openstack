template defaults/openstack/dicts;

variable OPENSTACK_GLANCE_DB ?= dict();
variable OPENSTACK_GLANCE_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_GLANCE_DB_HOST,
    'dbname', 'glance',
    'dbuser', OPENSTACK_GLANCE_DB_USERNAME,
    'dbpassword', OPENSTACK_GLANCE_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_HEAT_DB ?= dict();
variable OPENSTACK_HEAT_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_HEAT_DB_HOST,
    'dbname', 'heat',
    'dbuser', OPENSTACK_HEAT_DB_USERNAME,
    'dbpassword', OPENSTACK_HEAT_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_KEYSTONE_DB ?= dict();
variable OPENSTACK_KEYSTONE_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_KEYSTONE_DB_HOST,
    'dbname', 'keystone',
    'dbuser', OPENSTACK_KEYSTONE_DB_USERNAME,
    'dbpassword', OPENSTACK_KEYSTONE_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_NOVA_DB ?= dict();
variable OPENSTACK_NOVA_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_NOVA_DB_HOST,
    'dbname', 'nova',
    'dbuser', OPENSTACK_NOVA_DB_USERNAME,
    'dbpassword', OPENSTACK_NOVA_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_NOVA_API_DB ?= dict();
variable OPENSTACK_NOVA_API_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_NOVA_DB_HOST,
    'dbname', 'nova_api',
    'dbuser', OPENSTACK_NOVA_DB_USERNAME,
    'dbpassword', OPENSTACK_NOVA_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_NEUTRON_DB ?= dict();
variable OPENSTACK_NEUTRON_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_NEUTRON_DB_HOST,
    'dbname', 'neutron',
    'dbuser', OPENSTACK_NEUTRON_DB_USERNAME,
    'dbpassword', OPENSTACK_NEUTRON_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_CINDER_DB ?= dict();
variable OPENSTACK_CINDER_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_CINDER_DB_HOST,
    'dbname', 'cinder',
    'dbuser', OPENSTACK_CINDER_DB_USERNAME,
    'dbpassword', OPENSTACK_CINDER_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_CEILOMETER_DB ?= dict();
variable OPENSTACK_CEILOMETER_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_CEILOMETER_DB_HOST,
    'dbname', 'ceilometer',
    'dbuser', OPENSTACK_CEILOMETER_DB_USERNAME,
    'dbpassword', OPENSTACK_CEILOMETER_DB_PASSWORD,
    'dbprotocol', 'mongodb',
    'dbport', 27017,
));

variable OPENSTACK_BARBICAN_DB ?= dict();
variable OPENSTACK_BARBICAN_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_BARBICAN_DB_HOST,
    'dbname', 'barbican',
    'dbuser', OPENSTACK_BARBICAN_DB_USERNAME,
    'dbpassword', OPENSTACK_BARBICAN_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));

variable OPENSTACK_RABBITMQ_DICT ?= dict();
variable OPENSTACK_RABBITMQ_DICT = merge(SELF, dict(
    'rabbithosts', OPENSTACK_RABBITMQ_HOSTS,
    'rabbituser', OPENSTACK_RABBITMQ_USERNAME,
    'rabbitpassword', OPENSTACK_RABBITMQ_PASSWORD,
    'rabbitprotocol', 'rabbit',
));

variable OPENSTACK_AODH_DB ?= dict();
variable OPENSTACK_AODH_DB = merge(SELF, dict(
    'dbhost', OPENSTACK_AODH_DB_HOST,
    'dbname', 'aodh',
    'dbuser', OPENSTACK_AODH_DB_USERNAME,
    'dbpassword', OPENSTACK_AODH_DB_PASSWORD,
    'dbprotocol', 'mysql+pymysql',
    'dbport', 3306,
));
