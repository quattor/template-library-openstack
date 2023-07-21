unique template features/octavia/management-network/add_systemd_network;

# Create interface definition in network service
prefix '/software/components/metaconfig/services/{/etc/systemd/network/98-octavia-mgt-interface.network}';
'module' = 'tiny';
'convert/truefalse' = true;
bind '/software/components/metaconfig/services/{/etc/systemd/network/98-octavia-mgt-interface.network}/contents' = octavia_mgt_network_interface_config;
# Use schema defaults
'contents' = dict();
