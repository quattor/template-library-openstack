#!/bin/bash
echo "load variable"
%s
echo "[START] Databases upgrade"
echo "  Image service"
$DEBUG_DATABASES su -s /bin/sh -c "glance-manage db_sync" glance
echo "[DONE] Database configuration"
