#!/bin/bash
echo "load variable"
%s
echo "[START] Databases upgrade"
echo "  Orchestration service"
$DEBUG_DATABASES systemctl stop openstack-heat*
$DEBUG_DATABASES su -s /bin/sh -c "heat-manage db_sync" heat
$DEBUG_DATABASES systemctl start openstack-heat-api openstack-heat-api-cfn openstack-heat-engine
echo "[DONE] Database configuration"
