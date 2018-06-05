#!/bin/bash
echo "load variable"
%s

echo "[START] Databases upgrades"
echo "  Network service"
$DEBUG_DATABASES su -s /bin/sh -c "neutron-db-manage upgrade head" neutron
echo "[DONE] Database configuration"
