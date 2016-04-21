#!/bin/bash

DOMAIN=$1
DESCRIPTION=$2

openstack domain create --description "$DESCRIPTION" $DOMAIN
