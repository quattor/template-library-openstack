#!/bin/bash
echo "load variable"
%s

echo "[START] Databases upgrades"
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage api_db sync" nova
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
echo "[DONE] Database configuration"
