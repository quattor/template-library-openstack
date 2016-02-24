echo "[START] Network"
echo "  flat network"
$DEBUG_NETWORKS neutron net-create public --shared --provider:physical_network public \
  --provider:network_type flat
echo "  DHCP pool"
$DEBUG_NETWORKS neutron subnet-create public $NEUTRON_DEFAULT_NETWORK \
  --name public --allocation-pool \
  start=$NEUTRON_DEFAULT_DHCP_START,end=$NEUTRON_DEFAULT_DHPC_END \
  --dns-nameserver $NEUTRON_DEFAULT_NAMESERVER \
  --gateway $NEUTRON_DEFAULT_GATEWAY
echo "  Allow ping and SSH"
$DEBUG_NETWORKS nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
$DEBUG_NETWORKS nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
echo "[START] Network"
