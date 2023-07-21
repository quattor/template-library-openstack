unique template features/dashboard/config;

final variable OPENSTACK_DASHBOARD_OCTAVIA_UI_ENABLER ?= '_1482_project_load_balancer_panel.py';

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

#  httpd configuration
include 'features/httpd/openstack/config';

# memcache configuration
include 'features/memcache/config';

include 'features/dashboard/rpms';

# local_settings configuration
include if ( OS_HORIZON_CONFIGURE_LOCAL_SETTINGS ) 'features/dashboard/local_settings/config';

# WSGI configuration: overwrite the httpd conf file provided by the RPM
include 'features/dashboard/wsgi/config';

# Enable the Octavia section of the dashboard, if Octavia is configured
include 'components/symlink/config';
"/software/components/symlink/links" = {
    if ( is_defined(OS_OCTAVIA_PUBLIC_HOST) ) {
        SELF[length(SELF)] = dict(
            "name", format('/usr/lib/python3.6/site-packages/octavia_dashboard/enabled/%s', OPENSTACK_DASHBOARD_OCTAVIA_UI_ENABLER),
            "target", format('/etc/openstack-dashboard/enabled/%s', OPENSTACK_DASHBOARD_OCTAVIA_UI_ENABLER),
            "exists", false,
            "replace", nlist("all","yes"),
        );
    };

    if ( is_defined(SELF) ) {
        SELF;
    } else {
        null;
    };
}; 
