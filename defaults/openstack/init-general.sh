echo "load variable"

# Default Region
export REGION=%s

export OS_TOKEN=%s

# Internal variables
export ENDPOINT_TYPES="public internal"
export ADMIN_ENDPOINT_TYPE="admin"

export DEBUG_DOMAINS=$DEBUG
export DEBUG_DATABASES=$DEBUG
export DEBUG_SERVICES=$DEBUG
export DEBUG_ENDPOINTS=$DEBUG
export DEBUG_PROJECTS=$DEBUG
export DEBUG_ROLES=$DEBUG
export DEBUG_USERS=$DEBUG
export DEBUG_USERS_TO_ROLES=$DEBUG
export DEBUG_NETWORKS=$DEBUG

export KEYSTONE_URI="http://%s:5000"
export KEYSTONE_URL="http://%s:35357"

export ADMIN_USERNAME=%s
export ADMIN_PASSWORD=%s

export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=$ADMIN_USERNAME
export OS_PASSWORD=$ADMIN_PASSWORD
export OS_URL=$KEYSTONE_URL/v3
export OS_AUTH_URL=$OS_URL
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
