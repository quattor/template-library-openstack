#!/bin/bash
echo "load variable"
%s
# Keystone URL



echo "[START] Databases upgrades"
echo "  Identity service"
$DEBUG_DATABASES su -s /bin/sh -c "keystone-manage db_sync" keystone
echo "[DONE] Database configuration"
echo "[START] domain configuration"
echo "  default"
