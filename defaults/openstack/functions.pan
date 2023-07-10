declaration template defaults/openstack/functions;

# Function to load part of the config from a template, preserving the existing
# configuration, if any.
# Argument: structure template to load
function openstack_load_config = {
    if ( ARGC != 1 ) {
        error('openstack_load_config requires the name of the template to load');
    };

    template_file = ARGV[0];
    if ( !is_string(template_file) ) {
        error('openstack_load_config argument must be a string');
    };

    if ( is_defined(SELF) ) {
        config = SELF;
    } else {
        config = dict();
    };

    merge(config, create(template_file));
};


# Function to load the SSL/certificate information in the configuration
# Requires an argument saying if configuration must be done to simplify
# configuration of services.
function openstack_load_ssl_config = {
    if ( ARGC != 1 ) {
        error('openstack_load_ssl_config requires a boolean argument');
    };

    configure_ssl = ARGV[0];
    if ( !is_boolean(configure_ssl) ) {
        error('openstack_load_ssl_config argument must be a boolean');
    };

    if ( configure_ssl ) {
        openstack_load_config('features/ssl/openstack/config');
    } else if ( is_defined(SELF) ) {
        SELF;
    } else {
        null;
    };
};


# Function to add http packages to an OpenStack service
# Argument: true if SSL is enabled for the service
function openstack_add_httpd_packages = {
    if ( ARGC != 1 ) {
        error('openstack_add_httpd_packages requires a boolean argument');
    };

    configure_ssl = ARGV[0];
    if ( !is_boolean(configure_ssl) ) {
        error('openstack_add_httpd_packages argument must be a boolean');
    };

    pkg_repl('httpd');
    pkg_repl('python3-mod_wsgi');
    if ( configure_ssl ) {
        pkg_repl('mod_ssl');
    };

    SELF;
};

# Function to add a new dependency to a component.
# This function allows to avoiding duplicate dependencies.
#
# Calling sequence :
#    '/software/components/glitestartup/dependencies/pre' (or post) = glitestartup_add_dependency(dependency);
#
# with dependency a dependency or a list of dependencies.

function openstack_add_component_dependency = {
    function_name = 'openstack_add_component_dependency';
    deps = SELF;
    tmpdeps = dict();

    if ( (ARGC != 1) || (!is_string(ARGV[0]) && !is_list(ARGV[0]) ) ) {
        error('%s: argument must be a depencency or a list of dependencies', function_name);
    };

    if ( !is_defined(deps) ) {
        deps = list();
    } else if ( !is_list(deps) ) {
        error('%s: component dependencies must be a list', function_name);
    } else {
        foreach (i; dep; deps) {
            tmpdeps[dep] = '';
        };
    };

    if ( is_string(ARGV[0]) ) {
        newdeps = list(ARGV[0]);
    } else {
        newdeps = ARGV[0];
    };
    foreach (i; dep; newdeps) {
        if ( !exists(tmpdeps[dep]) ) {
            tmpdeps[dep] = '';
        }
    };

    deps = list();
    foreach (dep; v; tmpdeps) {
        deps[length(deps)] = dep;
    };

    if ( length(deps) > 0 ) {
        deps;
    } else {
        null;
    };
};
