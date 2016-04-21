#!/bin/bash

SERVICE=$1
ENDPOINT_TYPE=$2
REGION=$3
URI=$4

if openstack endpoint list | grep $SERVICE | grep $ENDPOINT_TYPE  ; then
    echo ' - already exists';
else
    openstack endpoint create --region $REGION $SERVICE $ENDPOINT_TYPE $URI;
fi
