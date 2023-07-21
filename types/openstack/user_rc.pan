declaration template types/openstack/user_rc;

type openstack_user_rc_options = {
    "OS_AUTH_URL" : type_hostURI
    "OS_IDENTITY_API_VERSION" : long(0..) = 3
    "OS_IMAGE_API_VERSION" : long(0..) = 2
    "OS_PASSWORD" : string
    "OS_PROJECT_DOMAIN_NAME" : string
    "OS_PROJECT_NAME" : string
    "OS_USER_DOMAIN_NAME" : string
    "OS_USERNAME" : string
    "OS_VOLUME_API_VERSION" : long(0..) = 3
};

# Use a config dict for the actual options to ease processing in TT file
type openstack_user_rc_config = {
    "config" : openstack_user_rc_options
};
