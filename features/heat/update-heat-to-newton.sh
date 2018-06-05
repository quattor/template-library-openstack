#!/bin/bash
echo "load variable"
%s
echo "[START] Databases upgrade"
echo "  Orchestration service"
$DEBUG_DATABASES su -s /bin/sh -c "heat-manage db_sync" heat
echo "[DONE] Database configuration"
