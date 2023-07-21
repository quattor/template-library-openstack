unique template features/nginx/openstack/rpms;

variable OS_NGINX_VERSION ?= "1.22";

'/software/components/spma/modules' = true;

'/software/modules' = {
    SELF['nginx'] = nlist('stream', OS_NGINX_VERSION,
                          'enable', true
                          );
    SELF;
};

'/software/packages' = pkg_repl('nginx');
