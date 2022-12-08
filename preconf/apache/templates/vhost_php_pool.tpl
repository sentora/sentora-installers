; old setting [{$vh.username}]
[{$vh.domain}]

user = {$vh.username}
group = {$vh.username}

listen = {$vh.domain}-fpm.sock

{if $webserver_user }
listen.owner = apache
listen.group = apache
; Restrict permissions to user and group only
listen.mode = 0660
{/if }

listen.allowed_clients = 127.0.0.1

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3

chdir = /

php_admin_value[error_log] = /var/sentora/logs/php-fpm/fpm-php.log
php_admin_flag[log_errors] = on
php_admin_value[memory_limit] = 256M
;php_admin_value[post_max_size] = 10M
;php_admin_value[upload_max_filesize] = 10M

# PHP Admin Values
{if $vh.use_openbase == "true"}
{if $vh.obasedir_in <> 0}
	php_admin_value[open_basedir] = {$vh.php_values}
{/if}
{/if}
{if $vh.use_suhosin == "true"}
{if $vh.suhosin_in <> 0}
	{$vh.php_func_blacklist}
{/if}
{/if}
	php_admin_value[upload_tmp_dir] = {$vh.php_upload_dir}
	php_admin_value[session.save_path] = {$vh.php_session_path}
