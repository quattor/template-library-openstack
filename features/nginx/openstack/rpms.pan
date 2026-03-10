unique template features/nginx/openstack/rpms;

variable OS_NGINX_VERSION ?= "1.24";

include 'components/spma/config';
'/software/components/spma/modules' = true;

'/software/modules' = {
    SELF['nginx'] = dict(
        'stream', OS_NGINX_VERSION,
        'enable', true,
    );
    SELF;
};

'/software/packages' = pkg_repl('nginx');
