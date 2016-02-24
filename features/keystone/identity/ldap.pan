unique template features/keystone/identity/ldap;

# If ldap is used as backend, we configure a openldap server
include 'features/openldap/config';

# keystone.conf file is already populate with some common variable
# We add ldap configuration variable
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'contents/identity/domain_specific_drivers_enabled' = 'True';
'contents/identity/domain_config_dir' = '/etc/keystone/domains';
'contents/identity/driver' = 'ldap';
'contents/resource/driver' = 'sql';
'contents/assignment/driver' = 'sql';

# All ldap configuration is put on /etc/keystone/domains/keystone.DOMAIN_NAME.conf
prefix '/software/components/metaconfig';
'services' = {
  # default domain is still on SQL
    SELF[escape('/etc/keystone/domains/keystone.default.conf')] = dict(
              'module', 'tiny',
    );
    SELF[escape('/etc/keystone/domains/keystone.default.conf')]['contents']['identity'] = dict('driver', 'sql');

    # foreach domain, populate the configuration file
    foreach(domain;params;OS_KEYSTONE_IDENTITY_LDAP_PARAMS) {
    # Populate configuration file with some default value
    SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')] = dict(
      'module', 'tiny',
      'contents', dict('ldap',dict()),
    );
    # Others domain is on ldap
    SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')]['contents']['identity'] = dict('driver', 'ldap');
    SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')]['contents']['ldap'] = dict(
      'use_dump_member', 'False',
      'allow_subtree_delete', 'False',
      'user_objectclass', 'inetOrgPerson',
      'user_allow_create', 'False',
      'user_allow_update', 'False',
      'user_allow_delete', 'False',
      'group_objectclass', 'groupOfNames',
      'group_allow_create', 'False',
      'group_allow_update', 'False',
      'group_allow_delete', 'False',
    );
    # Verify if all needed parameters exists
    if (!exists(params['url'])) {
      error('LDAP identity need params [url]');
        };
    if (!exists(params['user'])) {
      error('LDAP identity need params [user]');
    };
    if (!exists(params['password'])) {
      error('LDAP identity need params [password]');
    };
    if (!exists(params['suffix'])) {
      error('LDAP identity need params [suffix]');
    };
    if (!exists(params['user_tree_dn'])) {
      error('LDAP identity need params [user_tree_dn]');
    };
    if (!exists(params['group_tree_dn'])) {
      error('LDAP identity need params [group_tree_dn]');
    };

    foreach(attribute;attribute_value;params) {
      SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')]['contents']['ldap'][attribute] = attribute_value;
    };
  };
  SELF;
};
