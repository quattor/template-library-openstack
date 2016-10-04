#!/bin/bash
echo "load variable"
%s
export NOVA_URL="http://%s:8774/v2/%%\(tenant_id\)s"

export NOVA_USER=%s
export NOVA_PASSWORD=%s

echo "[START] Databases configuration"
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
echo "[DONE] Database configuration"

echo "[START] service configuration"
echo "  nova"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'compute' "Openstack Compute" 'nova'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Nova endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'compute' $endpoint_type $REGION $NOVA_URL
done
echo "[END] endpoints configuration"

echo "[START] User configuration"
echo "  nova user [$NOVA_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $NOVA_USER $NOVA_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for nova"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $NOVA_USER 'admin' 'service'
echo "[END] Role configuration"
