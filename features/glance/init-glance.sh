#!/bin/bash
echo "load variable"
%s
export GLANCE_URL="http://%s:9292"

export GLANCE_USER=%s
export GLANCE_PASSWORD=%s

echo "[START] Databases configuration"
echo "  Image service"
$DEBUG_DATABASES su -s /bin/sh -c "glance-manage db_sync" glance
echo "[DONE] Database configuration"

echo "[START] service configuration"
echo "  glance"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'image' "Openstack Image Service" 'glance'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Glance endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'image' $endpoint_type $REGION $GLANCE_URL
done
echo "[END] endpoints configuration"


echo "[START] User configuration"
echo "  glance user [$GLANCE_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $GLANCE_USER $GLANCE_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for glance"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $GLANCE_USER 'admin' 'service'
echo "[END] Role configuration"
