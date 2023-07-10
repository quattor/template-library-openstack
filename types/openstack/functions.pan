declaration template types/openstack/functions;

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
