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
