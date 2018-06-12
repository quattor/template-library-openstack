#!/bin/bash
echo "load variable"
%s
echo "[START] Databases upgrades"
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db online_data_migrations" nova
$DEBUG_DATABASES systemctl stop openstack-nova-api openstack-nova-console openstack-nova-conductor openstack-nova-scheduler openstack-nova-novncproxy
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage api_db sync" nova
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
$DEBUG_DATABASES systemctl start openstack-nova-api openstack-nova-console openstack-nova-conductor openstack-nova-scheduler openstack-nova-novncproxy
echo "[DONE] Database configuration"
