#!/bin/bash
echo "load variable"
%s
export NEUTRON_URL="http://%s:9696"

export NEUTRON_USER=%s
export NEUTRON_PASSWORD=%s
export NEUTRON_DEFAULT_NETWORK=%s
export NEUTRON_DEFAULT_DHCP_START=%s
export NEUTRON_DEFAULT_DHPC_END=%s
export NEUTRON_DEFAULT_GATEWAY=%s
export NEUTRON_DEFAULT_NAMESERVER=%s


echo "[START] Databases configuration"
echo "  Network service"
$DEBUG_DATABASES su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
echo "[DONE] Database configuration"

echo "[START] service configuration"
echo "  neutron"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'network' "Openstack Networking" 'neutron'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Neutron endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'network' $endpoint_type $REGION $NEUTRON_URL
done
echo "[END] endpoints configuration"

echo "[START] User configuration"
echo "  neutron user [$NEUTRON_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $NEUTRON_USER $NEUTRON_PASSWORD $OPENSTACK_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for Neutron"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $NEUTRON_USER 'admin' 'service'
echo "[END] Role configuration"
