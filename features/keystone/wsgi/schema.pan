declaration template features/keystone/wsgi/schema;

include 'types/openstack/httpd';


type openstack_keystone_httpd_oidc_provider = {
    'allowed_claims' ? string[]
    'ClientID' : string
    'ClientSecret' : string
    'CryptoPassphrase' : string
    'dashboard_menu' ? string
    'ProviderMetadataURL' : type_hostURI
    'RedirectURI' : type_hostURI
};


type openstack_keystone_httpd_oidc = {
    'oidc' : openstack_keystone_httpd_oidc_provider{}
};
