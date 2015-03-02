unique template repository/config/openstack;
 
include { 'quattor/functions/repository' };

@{
desc = defines the variant of the OpenStack RPM repository to use (typically the OpenStack version).\
The full repository template name will be built appending the version, os, arch. 
values = any string
default = icehouse
required = no
}
variable REPOSITORY_OPENSTACK_VARIANT ?= 'icehouse';

variable REPOSITORY_OPENSTACK_BASE ?= REPOSITORY_OPENSTACK_VARIANT + '_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

variable REPOSITORY_EPEL ?= 'epel_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

variable YUM_SNAPSHOT_NS ?= 'repository/snapshot';

variable YUM_OPENSTACK_SNAPSHOT_NS ?= YUM_SNAPSHOT_NS;

variable YUM_OPENSTACK_SNAPSHOT_DATE ?= if ( is_null(YUM_OPENSTACK_SNAPSHOT_DATE) ) {
  SELF;
} else {
  YUM_SNAPSHOT_DATE;
};

include { 'repository/config/quattor' };

variable OPENSTACK_REPOSITORY_LIST ?= {
  SELF[length(SELF)] = REPOSITORY_OPENSTACK_BASE;
  SELF[length(SELF)] = REPOSITORY_EPEL;

  SELF;
};

'/software/repositories' = {
  add_repositories(OPENSTACK_REPOSITORY_LIST,YUM_OPENSTACK_SNAPSHOT_NS);
};
