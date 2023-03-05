# Configuration for Sentora control panel SSL.
<VirtualHost *:443>
ServerAdmin {$cp.server_admin}
DocumentRoot "{$cp.server_root}"
ServerName {$cp.server_name}

<Directory "{$cp.server_root}">
    Options +FollowSymLinks -Indexes
    AllowOverride All
{if $cp.grant == '1'}
    Require all granted
{/if}
</Directory>

AddType application/x-httpd-php .php
#php_admin_value open_basedir "/var/sentora/:/etc/sentora/"
php_admin_value sp.configuration_file "/etc/sentora/configs/php/sp/sentora.rules"

# PHP Admin Values
php_admin_value session.save_path "/var/sentora/sessions"

ErrorLog "{$cp.log_dir}sentora-error.log" 
CustomLog "{$cp.log_dir}sentora-access.log" combined
CustomLog "{$cp.log_dir}sentora-bandwidth.log" common

{if $loaderrorpages <> "0"}
{foreach $loaderrorpages as $errorpages}
{$errorpages}
{/foreach}
{/if}

{if $panel_ssl_txt != null }
{$panel_ssl_txt}
{/if}

# Custom settings are loaded below this line (if any exist)
{$global_zpcustom}
</VirtualHost>