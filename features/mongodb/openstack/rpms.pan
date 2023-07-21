unique template features/mongodb/openstack/rpms;

@{
desc = MongoDB version, to help selecting the package repository to use
values = string
default = 6.0
required = non
}
variable OS_MONGODB_VERSION ?= "6.0";

'/software/packages' = {
    pkg_repl('mongodb-org-server');

    SELF;
};
