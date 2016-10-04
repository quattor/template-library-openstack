#!/bin/bash
USERNAME=$1
PASSWORD=$2
DOMAIN=$3

openstack user create --domain $DOMAIN --password $PASSWORD $USERNAME
