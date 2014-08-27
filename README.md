template-library-openstack
==========================

Template library for configuring OpenStack services


Keystone
========

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:
openstack-db --init --service keystone --password KEYSTONE_DB_PASSWORD


Glance
======

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:
openstack-db --init --service glance --password GLANCE_DB_PASSWORD
/root/sbin/create-glance-endpoints


Cinder
======

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:
openstack-db --init --service cinder --password CINDER_DB_PASSWORD
/root/sbin/create-cinder-endpoints
