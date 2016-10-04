template defaults/openstack/ha;

#########################
# HA Specific Variables #
#########################

variable OPENSTACK_RABBITMQ_CLUSTER_SECRET ?= if (OPENSTACK_HA) {error('OPENSTACK_RABBITMQ_CLUSTER_SECRET must be set for high availability');} else {null;};
variable OPENSTACK_RABBITMQ_HOSTS ?= if (OPENSTACK_HA) {error('OPENSTACK_RABBITMQ_HOSTS must be set for high availability');} else {null;};
variable OPENSTACK_MEMCACHE_HOSTS ?= if (OPENSTACK_HA) {error('OPENSTACK_MEMCACHE_HOSTS must be set for high availability');} else {null;};
variable OPENSTACK_FLOATING_IP ?= if (OPENSTACK_HA) {error('OPENSTACK_FLOATING_IP must be set for high availability');} else {null;};
variable OPENSTACK_KEEPALIVED_ROUTER_ID ?= if (OPENSTACK_HA) {error('OPENSTACK_FLOATING_IP must be set for high availability');} else {null;};
variable OPENSTACK_LOADBALANCER_MASTER ?= if (OPENSTACK_HA) {error('OPENSTACK_LOADBALANCER_MASTER must be set for high availability');} else {null;};
variable OPENSTACK_SERVERS ?= if (OPENSTACK_HA) {error('OPENSTACK_SERVERS must be set for high availability');} else {null;};
variable OPENSTACK_KEYSTONE_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_NOVA_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_NEUTRON_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_CINDER_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_CEILOMETER_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_HEAT_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_GLANCE_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
variable OPENSTACK_HORIZON_SERVERS ?= if (OPENSTACK_HA) {OPENSTACK_SERVERS;} else {null;};
