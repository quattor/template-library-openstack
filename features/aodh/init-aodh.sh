#!/bin/bash
echo "load variable"
%s
export AODH_ORCHESTRATION_URL="https://%s:8042"
export AODH_CLOUDFORMATION_URL="https://%s:8042"

export AODH_USER=%s
export AODH_PASSWORD=%s
export AODH_STACK_DOMAIN=%s
export AODH_DOMAIN_ADMIN_USER=%s
export AODH_DOMAIN_ADMIN_PASSWORD=%s


echo "[START] Domain configuration"
$DEBUG_DOMAINS quattor_openstack_add_domain.sh $AODH_STACK_DOMAIN "Stack projects and users"
echo "[DONE] Domain configuration"

echo "[START] Databases configuration"
echo "  Orchestration service"
$DEBUG_DATABASES su -s /bin/sh -c "aodh-manage db_sync" aodh
echo "[DONE] Database configuration"

echo "[START] service configuration"

echo "  aodh"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'aodh' "Telemetry" 'alarming'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Heat endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'alarming' $endpoint_type $REGION $AODH_ORCHESTRATION_URL
echo "[END] endpoints configuration"

echo "[START] Role configuration"
echo "  role aodh_stack_owner"
$DEBUG_ROLES quattor_openstack_add_role.sh 'aodh_stack_owner'
echo "[END] Role configuration"

echo "[START] User configuration"
echo "  aodh user [$AODH_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $AODH_USER $AODH_PASSWORD $OPENSTACK_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for Aodh"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $AODH_USER 'admin' 'service'
echo "[END] Role configuration"
