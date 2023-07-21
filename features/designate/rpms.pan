unique template features/designate/rpms;

# Install all RPM needed by designate
'/software/packages' = {
  # OpenStack specific RPMs
  pkg_repl('openstack-designate-agent');
  pkg_repl('openstack-designate-api');
  pkg_repl('openstack-designate-central');
  pkg_repl('openstack-designate-common');
  pkg_repl('openstack-designate-mdns');
  pkg_repl('openstack-designate-pool-manager');
  pkg_repl('openstack-designate-sink');
  pkg_repl('openstack-designate-zone-manager');

  # Official RPMS
  pkg_repl('bind');
  pkg_repl('bind-utils');
};

