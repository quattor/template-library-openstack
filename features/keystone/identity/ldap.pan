unique template features/keystone/identity/ldap;

# If ldap is used as backend, we configure a openldap server
include 'features/openldap/config';

# keystone.conf file is already populate with some common variable
# We add ldap configuration variable
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'contents/identity/domain_specific_drivers_enabled' = 'True';
'contents/identity/domain_config_dir' = '/etc/keystone/domains';
'contents/identity/driver' = 'sql';
'contents/resource/driver' = 'sql';
'contents/assignment/driver' = 'sql';

# All ldap configuration is put on /etc/keystone/domains/keystone.DOMAIN_NAME.conf
prefix '/software/components/metaconfig';
'services' = {
    # the default identity driver for multi domain is SQL

    # foreach domain, populate the configuration file
    foreach(domain; params; OPENSTACK_KEYSTONE_IDENTITY_LDAP_PARAMS) {

        # Verify if all needed parameters exists
        # TODO: force via schema!
        mandatory = list('url', 'user', 'password', 'suffix', 'user_tree_dn', 'group_tree_dn');
        foreach (idx; key; mandatory) {
            if (!exists(params[key])) {
                error(format('LDAP identity need params [%s]', key));
            };
        };

        contents = dict(
            # Others domain is on ldap
            'identity', dict('driver', 'ldap'),
            'ldap', merge(params, dict(
                'use_dump_member', 'False',
                'allow_subtree_delete', 'False',
                'user_allow_create', 'False',
                'user_allow_update', 'False',
                'user_allow_delete', 'False',
                'group_allow_create', 'False',
                'group_allow_update', 'False',
                'group_allow_delete', 'False',
            )),
        );

        # Populate configuration file with some default value
        SELF[escape('/etc/keystone/domains/keystone.' + domain + '.conf')] = dict(
            'module', 'tiny',
            'contents', contents,
        );
    };
    SELF;
};
