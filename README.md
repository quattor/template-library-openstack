template-library-openstack
==========================

Template library for configuring OpenStack services

These templates permit to configure an OpenStack Cloud. It has been
successfully used to configure an OpenStack Cloud at IPHC, with the
following network architecture:
http://docs.openstack.org/security-guide/content/networking-architecture.html

Further informations for an OpenStack installation on RedHat and derivatives
can be obtained on:
http://docs.openstack.org/icehouse/install-guide/install/yum/content/


Controller Node Installation
============================

Keystone
========

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:  
`# su -s /bin/sh -c "keystone-manage db_sync" keystone`

Glance
======

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:  
`# su -s /bin/sh -c "glance-manage db_sync" glance`  
`# /root/sbin/create-glance-endpoints`

Nova
====

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:  
`# su -s /bin/sh -c "nova-manage db sync" nova`  
`# /root/sbin/create-nova-endpoints`

Neutron
=======

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:  
`# /root/sbin/create-neutron-endpoints`

Cinder
======

Most of the configuration is performed by Quattor. Once the host is
configured, you have to execute the following command:  
`# su -s /bin/sh -c "cinder-manage db sync" cinder`  
`# /root/sbin/create-cinder-endpoints`

Network Node Installation
=========================

Quattor performs most of the configuration if you are using the following
code in your ncm-network component:  
https://github.com/quattor/configuration-modules-core/pull/423

Note that working with unsupported NIC drivers (like "be2net") might lead
to hangs in TCP connections when VLANs are used with OVS. In order to
workaround this issue, you can enable "VLAN Splinters" for the interface.
To do this, just add the following line to the `/etc/rc.local` file:  
`ovs-vsctl set interface <DATA_INTERFACE> other-config:enable-vlan-splinters=true`

Compute Node Installation
=========================

Quattor performs most of the configuration if you are using the following
code in your ncm-network component:
https://github.com/quattor/configuration-modules-core/pull/423

Note that working with unsupported NIC drivers (like "be2net") might lead
to hangs in TCP connections when VLANs are used with OVS. In order to
workaround this issue, you can enable "VLAN Splinters" for the interface.
To do this, just add the following line to the  `/etc/rc.local` file:  
`ovs-vsctl set interface <DATA_INTERFACE> other-config:enable-vlan-splinters=true`
