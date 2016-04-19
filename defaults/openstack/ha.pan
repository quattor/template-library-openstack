template defaults/openstack/ha;

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
