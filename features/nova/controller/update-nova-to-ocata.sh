#!/bin/bash
echo "load variable"
%s

export PLACEMENT_USER=%s
export PLACEMENT_PASSWORD=%s
export PLACEMENT_URL="https://%s:8778"

echo "[START] Set up Placement"
echo "Create user"
$DEBUG_USERS openstack user create --domain default --password "$PLACEMENT_PASSWORD"  $PLACEMENT_USER
echo "Add role"
$DEBUG_USERS_TO_ROLES openstack role add --project service --user $PLACEMENT_USER admin
echo "Add service"
$DEBUG_SERVICES openstack service create --name placement --description "Placement API" placement
echo "Add Endpoints"
$DEBUG_ENDPOINTS openstack endpoint create --region $REGION placement public $PLACEMENT_URL
$DEBUG_ENDPOINTS openstack endpoint create --region $REGION placement internal $PLACEMENT_URL
$DEBUG_ENDPOINTS openstack endpoint create --region $REGION placement admin $PLACEMENT_URL
echo "[DONE] Set up placement"


echo "[START] Configure cells v2"
$DEBUG_DATABASES systemctl stop openstack-nova*
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage --config-file /etc/nova/nova.conf cell_v2 create_cell --name=cell1 --verbose" nova
echo "[DONE] Configure cells v2"


echo "[START] Databases upgrades"
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage api_db sync" nova
$DEBUG_DATABASES systemctl start openstack-nova-api openstack-nova-console openstack-nova-conductor openstack-nova-scheduler openstack-nova-novncproxy
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
$DEBUG_DATABASES CELL_UUID=$(nova-manage cell_v2 list_cells | grep "cell1" | cut -d"|" -f3)
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage cell_v2 map_instances --cell_uuid $CELL_UUID" nova

echo "[DONE] Database configuration"
