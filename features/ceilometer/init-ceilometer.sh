#!/bin/bash

%s

export CEILOMETER_URL="http://%s:8777"

export CEILOMETER_DB_HOST=%s
export CEILOMETER_DB_USER=%s
export CEILOMETER_DB_PASSWORD=%s
export CEILOMETER_USER=%s
export CEILOMETER_PASSWORD=%s

echo "[START] Databases configuration"
echo "  Telemetry Service"
$DEBUG_DATABASES mongo --host $CEILOMETER_DB_HOST --eval "
  db = db.getSiblingDB('ceilometer');
  db.createUser({user: $CEILOMETER_DB_USER,
  pwd: $CEILOMETER_DB_PASSWORD,
  roles: [ 'readWrite', 'dbAdmin' ]})"
echo "[DONE] Database configuration"


echo "[START] service configuration"
echo "  ceilometer"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'metering' "Telemetry" 'ceilometer'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Ceilometer endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'metering' $endpoint_type $REGION $CEILOMETER_URL
done
echo "[END] endpoints configuration"

echo "[START] User configuration"
echo "  ceilometer user [$CEILOMETER_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $CEILOMETER_USER $CEILOMETER_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for ceilometer"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $CEILOMETER_USER 'admin' 'service'
echo "[END] Role configuration"
