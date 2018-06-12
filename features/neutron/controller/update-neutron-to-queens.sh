#!/bin/bash
echo "load variable"
%s

echo "[START] Databases upgrades"
echo "  Network service"
$DEBUG_DATABASES systemctl stop neutron*
$DEBUG_DATABASES su -s /bin/sh -c "neutron-db-manage upgrade head" neutron
$DEBUG_DATABASES systemctl start neutron-server
echo "[DONE] Database configuration"
