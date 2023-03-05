SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
SSLHonorCipherOrder off
SSLEngine On
SSLCertificateFile {$vh.hosted_dir}{$vh.vhost_user}/ssl/{$vh.server_name}/cert.pem
SSLCertificateKeyFile {$vh.hosted_dir}{$vh.vhost_user}/ssl/{$vh.server_name}/privkey.pem
SSLCertificateChainFile {$vh.hosted_dir}{$vh.vhost_user}/ssl/{$vh.server_name}/chain.pem
SSLCompression off