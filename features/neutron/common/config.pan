unique template features/neutron/common/config;

# Create symlink from /etc/neutron/plugins/ml2/ml2_conf.ini to /etc/neutron/plugin.ini
include 'components/symlink/config';
prefix '/software/components/symlink';
'links' = {
  SELF[length(SELF)] = dict(
    'exists', false,
    'name', '/etc/neutron/plugin.ini',
    'replace', dict( 'all', 'yes'),
    'target', '/etc/neutron/plugins/ml2/ml2_conf.ini'
  );
  SELF;
};
