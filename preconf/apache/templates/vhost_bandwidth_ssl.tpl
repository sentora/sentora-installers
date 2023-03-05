# DOMAIN: {$vh.server_name}
<virtualhost {$vh.server_ip}:{$vh.ssl_port_in}>
ServerName {$vh.server_name}
ServerAlias {$vh.server_alias}
ServerAdmin {$vh.server_admiin}
DocumentRoot "{$vh.static_dir}bandwidthexceeded"
<Directory "{$vh.static_dir}bandwidthexceeded">
    Options +FollowSymLinks -Indexes
    AllowOverride All
{if $vh.grant == '1'}
    Require all granted
{/if}
</Directory>
AddType application/x-httpd-php .php3 .php
DirectoryIndex index.html index.htm index.php index.asp index.aspx index.jsp index.jspa index.shtml index.shtm

{if $vh.ssl_tx != null }
# SSL Engine settings (if any exist)
{$vh.ssl_tx}
# END SSL Engine settings (if any exist)
{/if}

</virtualhost>