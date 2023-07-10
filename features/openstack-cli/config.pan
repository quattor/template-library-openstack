unique template features/openstack-cli/config;

'/software/packages' = {
  pkg_repl('python3-openstackclient');
  pkg_repl('python3-keystoneclient');
  pkg_repl('python3-glanceclient');
  pkg_repl('python3-cinderclient');
  pkg_repl('python3-neutronclient');
  pkg_repl('python3-novaclient');
  pkg_repl('python3-magnumclient');
};

