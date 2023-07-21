unique template features/ceilometer/meters/nova/snmp;

include 'defaults/openstack/config';

# Add snmpd packages
include 'features/ceilometer/meters/nova/rpms/snmp';

# Enable snmpd
include 'components/systemd/config';
prefix '/software/components/systemd/unit';
'snmpd/startstop' = true;

# Configure snmpd.conf
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/snmp/snmpd.conf}';
'module' = 'snmp/snmpd';

# Deamon to restart
'daemons/snmpd' = 'restart';

# system information
'contents/main/sysLocation' = OS_SNMPD_LOCATION;
'contents/main/sysContact' = OS_SNMPD_CONTACT;
'contents/main/access' = 'ConfigGroup ""      any       noauth    exact  systemview none none';
'contents/main/com2sec' = 'ConfigUser  default       ' + OS_SNMPD_COMMUNITY;
'contents/main/view' = 'systemview    included   .1';
'contents/main/agentAddress' = 'udp:'+OS_SNMPD_IP+':161';
'contents/group/' = list('ConfigGroup v2c           ConfigUser');
