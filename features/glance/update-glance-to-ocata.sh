#!/bin/bash
echo "load variable"
%s
echo "[START] Databases upgrade"
echo "  Image service"
$DEBUG_DATABASES systemctl stop openstack*
$DEBUG_DATABASES su -s /bin/sh -c "glance-manage db_sync" glance
$DEBUG_DATABASES systemctl start openstack-glance-api openstack-glance-registry
echo "[DONE] Database configuration"
