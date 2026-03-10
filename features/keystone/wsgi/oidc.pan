unique template features/keystone/wsgi/oidc;

variable OS_KEYSTONE_FEDERATION_OIDC_PARAMS = {
    if ( length(SELF) == 0 ) {
        error('OS_KEYSTONE_FEDERATION_OIDC_PARAMS must contain at least one identity provider');
    } else if ( length(SELF) > 1 ) {
        error('More than one enry in OS_KEYSTONE_FEDERATION_OIDC_PARAMS is not yet supported');
    };

    foreach (identity_provider; params; SELF) {
        foreach (i; attr; list('ClientID', 'ClientSecret', 'CryptoPassphrase', 'ProviderMetadataURL')) {
            if ( ! is_defined(SELF[identity_provider][attr]) ) {
                error('%s: attribute missing in OS_KEYSTONE_FEDERATION_OIDC_PARAMS (%s)', identity_provider, attr);
            };
        };

        SELF[identity_provider]['RedirectURI'] = format(
            'https://%s:5000/v3/OS-FEDERATION/identity_providers/%s/protocols/openid/auth',
            OS_KEYSTONE_PUBLIC_HOST,
            identity_provider,
        );
    };

    SELF;
};


include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/keystone-oidc.include}';
'module' = 'openstack/wsgi-keystone-oidc';
'daemons/httpd' = 'restart';
bind '/software/components/metaconfig/services/{/etc/httpd/conf.d/keystone-oidc.include}/contents' = openstack_keystone_httpd_oidc;

'contents/oidc' = OS_KEYSTONE_FEDERATION_OIDC_PARAMS;


# Load TT file to configure the keystone OIDCq parameters
# Run metaconfig in case the TT file was modified and configuration must be regenerated
include 'components/filecopy/config';
prefix '/software/components/filecopy';
'dependencies/post' = openstack_add_component_dependency('metaconfig');
prefix 'services/{/usr/share/templates/quattor/metaconfig/openstack/wsgi-keystone-oidc.tt}';
'config' = file_contents('features/keystone/wsgi/keystone-oidc.tt');
'perms' = '0644';


