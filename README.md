# openstack-liberty

## Installation
* Install repository under cfg/openstack-liberty
* Add cfg/openstack-liberty into cluster.build.properties

## Usage
* Create a template site/openstack/config

Look @ defaults/openstack/config.pan to have a list of all needed variables

## Some comment
* Default username and password are the same than those you have on RDO documentation
* We try to avoid filecopy config and prefer metaconfig usage. .tt file are provide with filecopy as far as it is not
available officialy

## Supported services
* Keystone: Apache configuration of keystone. sql or ldap backend is supported for user.
* Glance: Filesystem based glance is supported
* Nova
* Neutron: "self-service" or "provider" configuration is supported
* Cinder: "lvm" based backend is supported
* Ceilometer
* Heat

## TODO
* metaconfig is NOT typed yet
* Database is not populate
  * a init.sh script is created but not sure it work well (with fileconfig)
