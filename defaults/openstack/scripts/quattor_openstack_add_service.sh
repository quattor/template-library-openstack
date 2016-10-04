#!/bin/bash

SERVICE=$1
DESCRIPTION=$2
NAME=$3

if openstack service list | grep $SERVICE ; then
    echo " $SERVICE - already exists";
else
    openstack service create --name $NAME --description "$DESCRIPTION" $SERVICE;
fi
