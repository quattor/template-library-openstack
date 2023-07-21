unique template features/ceilometer/meters/nova/rpms/compute;

'/software/packages' = {
   pkg_repl('openstack-ceilometer-compute');
   pkg_repl('python3-ceilometerclient');
   pkg_repl('python3-pecan');

   SELF;
};
