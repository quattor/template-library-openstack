#!/bin/bash
echo "load variable"
%s
export HEAT_ORCHESTRATION_URL="http://%s:8004/v1/%%\(tenant_id\)s"
export HEAT_CLOUDFORMATION_URL="http://%s:8000/v1"

export HEAT_USER=%s
export HEAT_PASSWORD=%s
export HEAT_STACK_DOMAIN=%s
export HEAT_DOMAIN_ADMIN_USER=%s
export HEAT_DOMAIN_ADMIN_PASSWORD=%s


echo "[START] Domain configuration"
$DEBUG_DOMAINS quattor_openstack_add_domain.sh $HEAT_STACK_DOMAIN "Stack projects and users"
echo "[DONE] Domain configuration"

echo "[START] Databases configuration"
echo "  Orchestration service"
$DEBUG_DATABASES su -s /bin/sh -c "heat-manage db_sync" heat
echo "[DONE] Database configuration"

echo "[START] service configuration"

echo "  heat"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'orchestration' "Orchestration" 'heat'
echo "  heat cfn"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'cloudformation' "Orchestration" 'heat-cfn'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Heat endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'orchestration' $endpoint_type $REGION $HEAT_ORCHESTRATION_URL
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'cloudformation' $endpoint_type $REGION $HEAT_CLOUDFORMATION_URL
done
echo "[END] endpoints configuration"

echo "[START] Role configuration"
echo "  role heat_stack_owner"
$DEBUG_ROLES quattor_openstack_add_role.sh 'heat_stack_owner'
echo "[END] Role configuration"

echo "[START] User configuration"
echo "  heat user [$HEAT_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $HEAT_USER $HEAT_PASSWORD $OPENSTACK_PROJECT_DOMAIN_ID
echo "  heat domain admin user [$HEAT_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $HEAT_DOMAIN_ADMIN_USER $HEAT_DOMAIN_ADMIN_PASSWORD $HEAT_STACK_DOMAIN
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for Heat"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $HEAT_USER 'admin' 'service'
echo "[END] Role configuration"
