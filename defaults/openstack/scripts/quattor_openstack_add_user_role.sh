#!/bin/bash

USERNAME=$1
ROLE=$2
PROJECT=$3

openstack role add --project $PROJECT --project-domain default --user $USERNAME --user-domain default $ROLE
