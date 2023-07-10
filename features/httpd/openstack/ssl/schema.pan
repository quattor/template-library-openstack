declaration template features/httpd/openstack/ssl/schema;

type openstack_httpd_ssl_defaults = {
    'SSLCipherSuite' : string[] = list('ECDHE-ECDSA-AES128-GCM-SHA256',
                                       'ECDHE-RSA-AES128-GCM-SHA256', 
                                       'ECDHE-ECDSA-AES256-GCM-SHA384',
                                       'ECDHE-RSA-AES256-GCM-SHA384',
                                       'ECDHE-ECDSA-CHACHA20-POLY1305',
                                       'ECDHE-RSA-CHACHA20-POLY1305',
                                       'DHE-RSA-AES128-GCM-SHA256',
                                       'DHE-RSA-AES256-GCM-SHA384',
                                      )
    'SSLHonorCipherOrder' : boolean = false
    'SSLProtocol' : string[] = list('all',
                                    '-SSLv3',
                                    '-TLSv1',
                                    '-TLSv1.1',
                                   )
    'SSLSessionTickets' : boolean = false
    'SSLStaplingCache' : string = 'shmcb:logs/ssl_stapling(32768)'
    'SSLUseStapling' : boolean = true
};
