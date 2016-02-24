template defaults/openstack/ha;

variable OS_GLANCE_PORT = 9292;
variable OS_HEAT_CFN_PORT = 8000;
variable OS_HEAT_PORT = 8004;
variable OS_HEAT_PORTS = list(OS_HEAT_PORT,OS_HEAT_CFN_PORT);
variable OS_KEYSTONE_PORT = 5000;
variable OS_KEYSTONE_ADMIN_PORT = 35357;
variable OS_KEYSTONE_PORTS = list(OS_KEYSTONE_PORT,OS_KEYSTONE_ADMIN_PORT);
variable OS_NOVA_OSAPI_PORT = 8774;
variable OS_NOVA_EC2_PORT = 8773;
variable OS_NOVA_METADATA_PORT = 8774;
variable OS_NOVA_NOVNC_PORT = 6080;
variable OS_NOVA_PORTS = list(OS_NOVA_OSAPI_PORT, OS_NOVA_EC2_PORT, OS_NOVA_EC2_PORT, OS_NOVA_NOVNC_PORT);
variable OS_NEUTRON_PORT = 9696;
variable OS_CINDER_PORT = 8776;
variable OS_CEILOMETER_PORT = 8777;
variable OS_HORIZON_PORT = if (OS_SSL) { port = 443; } else { port = 80};


#########################
# HA Specific Variables #
#########################

variable OS_RABBITMQ_CLUSTER_SECRET ?= if (OS_HA) {error('OS_RABBITMQ_CLUSTER_SECRET must be set for high availability');} else {null;};
variable OS_RABBITMQ_HOSTS ?= if (OS_HA) {error('OS_RABBITMQ_HOSTS must be set for high availability');} else {null;};
variable OS_MEMCACHE_HOSTS ?= if (OS_HA) {error('OS_MEMCACHE_HOSTS must be set for high availability');} else {null;};
variable OS_FLOATING_IP ?= if (OS_HA) {error('OS_FLOATING_IP must be set for high availability');} else {null;};
variable OS_LOADBALANCER_MASTER ?= if (OS_HA) {error('OS_LOADBALANCER_MASTER must be set for high availability');} else {null;};
variable OS_SERVERS ?= if (OS_HA) {error('OS_SERVERS must be set for high availability');} else {null;};
variable OS_KEYSTONE_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_NOVA_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_NEUTRON_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_CINDER_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_CEILOMETER_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_HEAT_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_GLANCE_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
variable OS_HORIZON_SERVERS ?= if (OS_HA) {OS_SERVERS;} else {null;};
