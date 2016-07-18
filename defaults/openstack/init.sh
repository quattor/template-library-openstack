#!/bin/bash
echo "load variable"



# Keystone URL
export KEYSTONE_URI="http://%s:5000"
export KEYSTONE_URL="http://%s:35357"
export GLANCE_URL="http://%s:9292"
export NOVA_URL="http://%s:8774/v2/%%\(tenant_id\)s"
export NEUTRON_URL="http://%s:9696"
export HEAT_ORCHESTRATION_URL="http://%s:8004/v1/%%\(tenant_id\)s"
export HEAT_CLOUDFORMATION_URL="http://%s:8000/v1"
export CINDER_URL="http://%s:8776/v1/%%\(tenant_id\)s"
export CINDERV2_URL="http://%s:8776/v2/%%\(tenant_id\)s"
#

export ADMIN_USERNAME=%s
export ADMIN_PASSWORD=%s
export GLANCE_USER=%s
export GLANCE_PASSWORD=%s
export NOVA_USER=%s
export NOVA_PASSWORD=%s
export NEUTRON_USER=%s
export NEUTRON_PASSWORD=%s
export HEAT_USER=%s
export HEAT_PASSWORD=%s
export HEAT_STACK_DOMAIN=%s
export HEAT_DOMAIN_ADMIN_USER=%s
export HEAT_DOMAIN_ADMIN_PASSWORD=%s
export CINDER_USER=%s
export CINDER_PASSWORD=%s

export OS_TOKEN=%s
export NEUTRON_DEFAULT_NETWORK=%s
export NEUTRON_DEFAULT_DHCP_START=%s
export NEUTRON_DEFAULT_DHPC_END=%s
export NEUTRON_DEFAULT_GATEWAY=%s
export NEUTRON_DEFAULT_NAMESERVER=%s
#
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=$ADMIN_USERNAME
export OS_PASSWORD=$ADMIN_PASSWORD
export OS_URL=$KEYSTONE_URL/v3
export OS_AUTH_URL=$OS_URL
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2


export DEBUG_DOMAINS=$DEBUG
export DEBUG_DATABASES=$DEBUG
export DEBUG_SERVICES=$DEBUG
export DEBUG_ENDPOINTS=$DEBUG
export DEBUG_PROJECTS=$DEBUG
export DEBUG_ROLES=$DEBUG
export DEBUG_USERS=$DEBUG
export DEBUG_USERS_TO_ROLES=$DEBUG
export DEBUG_NETWORKS=$DEBUG




echo "[START] Domain configuration"
$DEBUG_DOMAINS quattor_openstack_add_domain.sh $HEAT_STACK_DOMAIN "Stack projects and users"
echo "[DONE] Domain configuration"

echo "[START] Databases configuration"
echo "  Identity service"
$DEBUG_DATABASES su -s /bin/sh -c "keystone-manage db_sync" keystone
echo "  Network service"
$DEBUG_DATABASES su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
echo "  Image service"
$DEBUG_DATABASES su -s /bin/sh -c "glance-manage db_sync" glance
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
echo "  Orchestration service"
$DEBUG_DATABASES su -s /bin/sh -c "heat-manage db_sync" heat
echo "  Block service"
$DEBUG_DATABASES su -s /bin/sh -c "cinder-manage db sync" cinder
echo "  Telemetry Service"
$DEBUG_DATABASES mongo --host $CEILOMETER_DB_HOST --eval "
  db = db.getSiblingDB('ceilometer');
  db.createUser({user: $CEILOMETER_DB_USER,
  pwd: $CEILOMETER_DB_PASSWORD,
  roles: [ 'readWrite', 'dbAdmin' ]})"
echo "[DONE] Database configuration"

echo "[START] service configuration"
systemctl start openstack-keystone
echo "  keystone"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'identity' "Openstack Identity" 'keystone'
echo "  glance"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'image' "Openstack Image Service" 'glance'
echo "  nova"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'compute' "Openstack Compute" 'nova'
echo "  neutron"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'network' "Openstack Networking" 'neutron'
echo "  heat"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'orchestration' "Orchestration" 'heat'
echo "  heat cfn"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'cloudformation' "Orchestration" 'heat-cfn'
echo "  cinder volume"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'volume' "OpenStack Block Storage" 'cinder'
echo "  cinder volumev2"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'volumev2' "OpenStack Block Storage" 'cinderv2'
echo "  ceilometer"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'metering' "Telemetry" 'ceilometer'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Identity endpoint"
for endpoint_type in $ENDPOINT_TYPES
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'identity' $endpoint_type $REGION "$KEYSTONE_URI/v2.0"
done
$DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'identity' $ADMIN_ENDPOINT_TYPE $REGION "$KEYSTONE_URI/v2.0"
echo "  Glance endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'image' $endpoint_type $REGION $GLANCE_URL
done
echo "  Nova endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'compute' $endpoint_type $REGION $NOVA_URL
done
echo "  Neutron endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'network' $endpoint_type $REGION $NEUTRON_URL
done
echo "  Heat endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'orchestration' $endpoint_type $REGION $HEAT_ORCHESTRATION_URL
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'cloudformation' $endpoint_type $REGION $HEAT_CLOUDFORMATION_URL
done
echo "  Cinder endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'volume' $endpoint_type $REGION $CINDER_URL
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'volumev2' $endpoint_type $REGION $CINDERV2_URL
done
echo "  Ceilometer endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'metering' $endpoint_type $REGION $CEILOMETER_URL
done
echo "[END] endpoints configuration"

echo "[START] Project configuration"
echo "  service project"
$DEBUG_PROJECTS quattor_openstack_add_project.sh 'service' "Service Project" $OS_PROJECT_DOMAIN_ID
echo "  admin project"
$DEBUG_PROJECTS quattor_openstack_add_project.sh 'admin' "Admin Project" $OS_PROJECT_DOMAIN_ID
echo "[END] Project configuration"

echo "[START] Role configuration"
echo "  admin role"
$DEBUG_ROLES quattor_openstack_add_role.sh 'admin'
echo "  role user"
$DEBUG_ROLES quattor_openstack_add_role.sh 'user'
echo "  role heat_stack_owner"
$DEBUG_ROLES quattor_openstack_add_role.sh 'heat_stack_owner'
echo "[END] Role configuration"

echo "[START] User configuration"
echo "  admin user [$ADMIN_USERNAME]"
$DEBUG_USERS quattor_openstack_add_user.sh $ADMIN_USERNAME $ADMIN_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "  glance user [$GLANCE_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $GLANCE_USER $GLANCE_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "  nova user [$NOVA_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $NOVA_USER $NOVA_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "  neutron user [$NEUTRON_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $NEUTRON_USER $NEUTRON_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "  heat user [$HEAT_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $HEAT_USER $HEAT_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "  heat domain admin user [$HEAT_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $HEAT_DOMAIN_ADMIN_USER $HEAT_DOMAIN_ADMIN_PASSWORD $HEAT_STACK_DOMAIN
echo "  cinder user [$CINDER_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $CINDER_USER $CINDER_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "  ceilometer user [$CEILOMETER_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $CEILOMETER_USER $CEILOMETER_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for admin"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $ADMIN_USERNAME 'admin' 'admin'
echo "  Role for glance"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $GLANCE_USER 'admin' 'service'
echo "  Role for nova"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $NOVA_USER 'admin' 'service'
echo "  Role for Neutron"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $NEUTRON_USER 'admin' 'service'
echo "  Role for Heat"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $HEAT_USER 'admin' 'service'
echo "  Role for cinder"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $CINDER_USER 'admin' 'service'
echo "  Role for ceilometer"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $CEILOMETER_USER 'admin' 'service'
echo "[END] Role configuration"
