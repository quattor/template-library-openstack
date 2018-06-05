#!/bin/bash
echo "load variable"

%s

echo "[START] Databases upgrade"
echo "  Block service"
$DEBUG_DATABASES su -s /bin/sh -c "cinder-manage db sync" cinder
echo "[DONE] Database configuration"
