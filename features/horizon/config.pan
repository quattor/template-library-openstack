unique template features/horizon/config;

final variable OPENSTACK_DASHBOARD_OCTAVIA_UI_ENABLER ?= '_1482_project_load_balancer_panel.py';

variable OS_NODE_SERVICES = append('horizon');

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

#  httpd configuration
include 'features/httpd/openstack/config';

# memcache configuration
include 'features/memcache/config';

include 'features/horizon/rpms';

# local_settings configuration
include if ( OS_HORIZON_CONFIGURE_LOCAL_SETTINGS ) 'features/horizon/local_settings/config';

# WSGI configuration: overwrite the httpd conf file provided by the RPM
# Apache is used instead of uwsgi as the RPM provides several files owned by apache user
include 'features/horizon/wsgi/config';

# Enable the Octavia section of the dashboard, if Octavia is configured
include 'components/symlink/config';
"/software/components/symlink/links" = {
    if ( is_defined(OS_OCTAVIA_PUBLIC_HOST) ) {
        SELF[length(SELF)] = dict(
            "name", format(
                '%s/octavia_dashboard/enabled/%s',
                PYTHON_MODULES_ROOT_DIR,
                OPENSTACK_DASHBOARD_OCTAVIA_UI_ENABLER
            ),
            "target", format('/etc/openstack-dashboard/enabled/%s', OPENSTACK_DASHBOARD_OCTAVIA_UI_ENABLER),
            "exists", false,
            "replace", dict("all", "yes"),
        );
    };

    if ( is_defined(SELF) ) {
        SELF;
    } else {
        null;
    };
};

# httpd: increase file limit
include 'components/systemd/config';
'/software/components/systemd/unit/httpd/file/config/service/LimitNOFILE' = 4096;


#########################################
# Configure SSL proxy if SSL is enabled #
#########################################
include if ( OS_HORIZON_PROTOCOL == 'https' ) 'features/horizon/nginx/config';
