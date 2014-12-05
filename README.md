template-library-openstack
==========================

Template library for configuring OpenStack services

These templates permit to configure an OpenStack Cloud. It has been
successfully used to configure an OpenStack Cloud at IPHC, with the
following network architecture:
http://docs.openstack.org/security-guide/content/networking-architecture.html

Further informations for an OpenStack installation on RedHat and derivatives
can be obtained on:
http://docs.openstack.org/havana/install-guide/install/yum/content/


Controller Node Installation
============================

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

Nova
====


Neutron
=======


Network Node Installation
=========================


Compute Node Installation
=========================


