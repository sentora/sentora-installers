# DOMAIN: {$vh.server_name}
<Virtualhost *:{$vh.server_port}>
ServerName {$vh.server_name}
{if $vh.server_alias != "" }
ServerAlias {$vh.server_alias}	
{/if}
ServerAdmin {$vh.server_admiin}
DocumentRoot "{$vh.server_root}"

<Directory {$vh.server_root}>
    Options +FollowSymLinks -Indexes
    AllowOverride All
{if $vh.grant == '1'}
    Require all granted
{/if}
</Directory>

{$vh.server_addtype}
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
DirectoryIndex index.html index.htm index.php index.asp index.aspx index.jsp index.jspa index.shtml index.shtm

# PHP Admin Values
{if $vh.use_openbase == "true"}
{if $vh.obasedir_in <> 0}
php_admin_value open_basedir {$vh.php_values}
{/if}
{/if}
{if $vh.use_suhosin == "true"}
{if $vh.suhosin_in <> 0}
{$vh.php_func_blacklist}
{/if}
{/if}
php_admin_value upload_tmp_dir {$vh.php_upload_dir}
php_admin_value session.save_path {$vh.php_session_path}

ErrorLog {$vh.error_log} 
CustomLog {$vh.access_log}
CustomLog {$vh.bandwidth_log}

{if $vhloaderrorpages <> "0"}
{foreach $vhloaderrorpages as $errorpages}
{$errorpages}
{/foreach}
{/if}

# Custom Global Settings (if any exist)
{$vh.global_vhcustom}
# Custom VH settings (if any exist)
{$vh.vh_custom_tx}
</virtualhost>