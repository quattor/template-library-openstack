#!/bin/bash
# RabbitMQ variable
export RABBITMQ_USERNAME=%s
export RABBITMQ_PASSWORD=%s

export DEBUG_RABBITMQ=$DEBUG

echo "[START] Rabbitmq configuration"
$DEBUG_RABBITMQ rabbitmqctl add_user $RABBITMQ_USERNAME $RABBITMQ_PASSWORD
$DEBUG_RABBITMQ rabbitmqctl set_permissions $RABBITMQ_USERNAME ".*" ".*" ".*"
echo "[DONE] Rabbitmq configuration"
