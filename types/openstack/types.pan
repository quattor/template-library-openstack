# This template defines types used in OpenStack configuration and not available as
# standard types.

declaration template types/openstack/types;

@documentation{
Defines a IP address and port of the form ip_addr:port.
Inspired from is_hostport() standard function but port is required to be present
}
function is_ip_port = {
    # Check cardinality and type of argument.
    if ( ARGC != 1 || !is_string(ARGV[0]) ) {
        error("usage: is_ip_port(string)");
    };

    # Split string into address and port fields.
    result = matches(ARGV[0], '^([^:]+)(?::(\d+))$');
    nmatch = length(result);

    # Must match both fileds
    if ( nmatch != 3 ) {
        error("is_ip_port: global pattern match for ip:port failed");
        return(false);
    };

    # Check that the address part is OK.
    address = result[1];
    if ( !is_ipv4(address) ) {
        error("is_ip_port: invalid address " + address);
        return(false);
    };

    # Check range of the port.
    port = to_long(result[2]);

    # Ensure that the range is OK.
    if ( !is_port(port) ) {
        error("is_ip_port: port out of range " + port);
        return(false);
    };

    # All OK.
    true;
};

type type_ip_port = string with {
    is_ip_port(SELF);
};


@documentation {
Check if the string is a valid Openstack ID with a format like:

    9f0819d5-9c34-4aa1-ae1a-80266919f6e8

Used by most OpenStack objects
};
function is_openstack_id = {
    # Check cardinality and type of argument.
    if ( ARGC != 1 || !is_string(ARGV[0]) ) {
        error("usage: is_openstack_id(string)");
    };

    if ( match(ARGV[0], '^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$') ) {
        true;
    } else {
        false;
    };
};

type type_openstack_id = string with {
    is_openstack_id(SELF);
};


@documentation {
Check if the string is a valid Openstack ID with the alternate format :

    9f0819d569c3474aa18ae1a380266919f6e8

Used by projects, users, roles
};
function is_openstack_id2 = {
    # Check cardinality and type of argument.
    if ( ARGC != 1 || !is_string(ARGV[0]) ) {
        error("usage: is_openstack_id(string)");
    };

    if ( match(ARGV[0], '^[0-9a-fA-F]{32}$') ) {
        true;
    } else {
        false;
    };
};

type type_openstack_id2 = string with {
    is_openstack_id2(SELF);
};


@documentation {
    function to validate keystone client configuration
};
function openstack_project_name_or_id = {
    if ( is_defined(SELF['project_domain_id']) && is_defined(SELF['project_domain_name']) ) {
        error('Either projoect_domain_id or project_domain_name must be defined, not both');
    } else if ( !is_defined(SELF['project_domain_id']) && !is_defined(SELF['project_domain_name']) ) {
        error('One of projoect_domain_id or project_domain_name must be defined');
    };

    if ( is_defined(SELF['user_domain_id']) && is_defined(SELF['user_domain_name']) ) {
        error('Either projoect_domain_id or user_domain_name must be defined, not both');
    } else if ( !is_defined(SELF['user_domain_id']) && !is_defined(SELF['user_domain_name']) ) {
        error('One of projoect_domain_id or user_domain_name must be defined');
    };

    true;
};

