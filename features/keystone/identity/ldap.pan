unique template features/keystone/identity/ldap;

# Add OpenLDAP clients
'/software/packages' =     pkg_repl('openldap-clients');

# keystone.conf file is already populate with some common variable
# We add ldap configuration variable
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'contents/identity/domain_specific_drivers_enabled' = true;
'contents/identity/domain_config_dir' = '/etc/keystone/domains';

# LDAP: for each domain, a distinct configuration file is created
# (/etc/keystone/domains/keystone.DOMAIN_NAME.conf)
prefix '/software/components/metaconfig';
'services' = {
    foreach(domain; params; OS_KEYSTONE_IDENTITY_LDAP_PARAMS) {
        # Populate configuration file with some default value
        SELF[escape(format('/etc/keystone/domains/keystone.%s.conf', domain))] = dict(
            'module', 'tiny',
            'contents', dict('ldap', dict()),
        );
        SELF[escape(format('/etc/keystone/domains/keystone.%s.conf', domain))]['daemons'] = dict(
            'httpd', 'restart',
        );
        # Others domain is on ldap
        SELF[escape(format('/etc/keystone/domains/keystone.%s.conf', domain))]['contents']['identity'] = dict(
            'driver', 'ldap',
        );
        SELF[escape(format('/etc/keystone/domains/keystone.%s.conf', domain))]['contents']['ldap'] = dict(
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

        foreach(attribute; attribute_value; params) {
            k = escape(format('/etc/keystone/domains/keystone.%s.conf', domain));
            SELF[k]['contents']['ldap'][attribute] = attribute_value;
        };
    };
    SELF;
};
