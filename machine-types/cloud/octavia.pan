unique template machine-types/cloud/octavia;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/octavia/config';
