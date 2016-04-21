#!/bin/bash

PROJECT=$1
DESCRIPTION=$2
DOMAIN=$3

openstack project create --domain $DOMAIN --description "$DESCRIPTION" $PROJECT
