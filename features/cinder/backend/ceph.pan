unique template features/cinder/backend/ceph;

# Add Ceph package
'/software/packages' = pkg_repl('ceph');

# Create ceph.conf for connecting the CEPH cluster
variable CEPH_CLUSTER_CONFIG ?= error('CEPH_CLUSTER_CONFIG required but undefined');
variable CEPH_NODE_VERSIONS ?= 'site/ceph/version';
include CEPH_NODE_VERSIONS;
include CEPH_CLUSTER_CONFIG;
include 'features/ceph/ceph_conf/config';
prefix '/software/components/metaconfig/services/{/etc/ceph/ceph.conf}';
'daemons/openstack-cinder-volume' = 'restart';
