unique template defaults/openstack/functions;

function openstack_load_config = {
  if (ARGC != 1 ) {
    error('openstack_load_config need a argument');
  };

  if (is_string(ARGV[0])) {
    config = create(ARGV[0]);
  } else if (!is_dict(ARGV[0])) {
    error('openstack_load_config need a string or a dict as argument');
  } else {
    config = ARGV[0];
  };

  foreach(k;v;config) {
    SELF[k] = v;
  };
  SELF;
};

# FIXME: As I use tiny metaconfig module, i can't just put list to have
# element1, element2, ...
function openstack_list_to_string = {
  if (ARGC != 1 ) {
    error('openstack_load_config need a argument');
  };

  if (is_list(ARGV[0])) {
    config = ARGV[0];
  } else  {
    error('openstack_list_to_string need a list as an argument');
  };

  result = '';

  foreach(k;v;config) {
    if (result != '') {
      result = format(
        '%s,%s',
        result,
        v
      );
    } else {
      result = v;
    };

    result;
  };
};

function openstack_dict_to_hostport_string = {
  if (ARGC != 1) {
     error('openstack_dict_to_hostport_string needs an argument');
  };

  if (is_dict(ARGV[0])) {
    config = ARGV[0];
  } else {
    error('openstack_dict_to_hostport_string needs a dict as an argument');
  };
  result = '';
  foreach(k;v;config) {
    if (result != '') {
      result = format(
        '%s,%s:%d',
        result,
        k,
        v
      );
    } else {
      result = format(
        '%s:%d',
        k,
        v
      );
    };

    result;
  };
};

function openstack_dict_to_connection_string = {
  if (ARGC != 1) {
     error('openstack_dict_to_connection_string needs an argument');
  };

  if (is_dict(ARGV[0])) {
    config = ARGV[0];
  } else {
    error('openstack_dict_to_connection_string needs a dict as an argument');
  };
  result = format(
    '%s://%s:%s@%s:%d/%s',
    config['dbprotocol'],
    config['dbuser'],
    config['dbpassword'],
    config['dbhost'],
    config['dbport'],
    config['dbname']
  );
  result;
};
