#!/bin/bash
echo "load variable"
%s
export BARBICAN_URL="http://%s:9311"

export BARBICAN_USER=%s
export BARBICAN_PASSWORD=%s

echo "[START] Databases configuration"
echo "  Key manager service"
$DEBUG_DATABASES su -s /bin/sh -c "barbican-manage db upgrade" barbican
echo "[DONE] Database configuration"

echo "[START] service configuration"
echo "  barbican"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'key-manager' "OpenStack Key Manager" 'barbican'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Barbican endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'key-manager' $endpoint_type $REGION $BARBICAN_URL
done
echo "[END] endpoints configuration"


echo "[START] User configuration"
echo "  barbican user [$BARBICAN_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $BARBICAN_USER $BARBICAN_PASSWORD $OPENSTACK_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for barbican"
$DEBUG_ROLES quattor_openstack_add_role.sh 'creator'
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $BARBICAN_USER 'admin' 'service'
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $BARBICAN_USER 'creator' 'service'
echo "[END] Role configuration"
