#!/bin/bash
echo "load variable"
%s
# Keystone URL



echo "[START] Databases upgrades"
echo "  Identity service"
$DEBUG_DATABASES systemctl stop httpd
$DEBUG_DATABASES su -s /bin/sh -c "keystone-manage db_sync" keystone
$DEBUG_DATABASES systemctl start httpd
echo "[DONE] Database configuration"
