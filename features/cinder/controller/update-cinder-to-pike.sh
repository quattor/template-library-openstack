#!/bin/bash
echo "load variable"

%s

export CINDERV3_URL="https://%s:8776/v3/%%\(project_id\)s"

echo "[START] Databases upgrade"
echo "  Block service"
$DEBUG_DATABASES systemctl stop openstack-cinder*
$DEBUG_DATABASES su -s /bin/sh -c "cinder-manage db sync" cinder
$DEBUG_DATABASES systemctl start openstack-cinder-api openstack-cinder-scheduler openstack-cinder-volume
echo "[DONE] Database configuration"

echo "[START] configure volumev3"
$DEBUG_SERVICES openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION 'volumev3' $endpoint_type $REGION $CINDERV3_URL
done
echo "[DONE] configure volumev3"
