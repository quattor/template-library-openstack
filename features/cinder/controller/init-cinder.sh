#!/bin/bash
echo "load variable"

%s

export CINDER_URL="http://%s:8776/v1/%%\(tenant_id\)s"
export CINDERV2_URL="http://%s:8776/v2/%%\(tenant_id\)s"
#

export CINDER_USER=%s
export CINDER_PASSWORD=%s

echo "[START] Databases configuration"
echo "  Block service"
$DEBUG_DATABASES su -s /bin/sh -c "cinder-manage db sync" cinder
echo "[DONE] Database configuration"

echo "[START] service configuration"
echo "  cinder volume"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'volume' "OpenStack Block Storage" 'cinder'
echo "  cinder volumev2"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'volumev2' "OpenStack Block Storage" 'cinderv2'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Cinder endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'volume' $endpoint_type $REGION $CINDER_URL
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'volumev2' $endpoint_type $REGION $CINDERV2_URL
done
echo "[END] endpoints configuration"

echo "[START] User configuration"

echo "  cinder user [$CINDER_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $CINDER_USER $CINDER_PASSWORD $OPENSTACK_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for cinder"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $CINDER_USER 'admin' 'service'
echo "[END] Role configuration"
