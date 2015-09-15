UPDATE `zpanel_core`.`x_groups` SET `ug_notes_tx` = 'Resellers have the ability to manage, create and maintain user accounts within Sentora.' WHERE `ug_id_pk` = '2';
UPDATE `zpanel_core`.`x_groups` SET `ug_notes_tx` = 'Users have basic access to Sentora.' WHERE `ug_id_pk` = '3';
UPDATE `zpanel_core`.`x_groups` SET `ug_notes_tx` = 'The main administration group, this group allows access to all areas of Sentora.' WHERE `ug_id_pk` = '1';

UPDATE `zpanel_core`.`x_modules` SET `mo_updateurl_tx` = NULL WHERE `mo_id_pk` = '46';
UPDATE `zpanel_core`.`x_modules` SET `mo_desc_tx` = 'Welcome to the Package Manager, using this module enables you to create and manage existing reseller packages on your Sentora hosting account.' WHERE `mo_id_pk` = '20';
UPDATE `zpanel_core`.`x_modules` SET `mo_updateurl_tx` = NULL WHERE `mo_id_pk` = '47';
UPDATE `zpanel_core`.`x_modules` SET `mo_desc_tx` = 'Check to see if there are any available updates to your version of the Sentora software.' WHERE `mo_id_pk` = '6';
UPDATE `zpanel_core`.`x_modules` SET `mo_desc_tx` = 'The backup manager module enables you to backup your entire hosting account including all your MySQL&reg; databases.' WHERE `mo_id_pk` = '12';
UPDATE `zpanel_core`.`x_modules` SET `mo_name_vc` = 'Sentora Config', `mo_folder_vc` = 'sentoraconfig', `mo_desc_tx` = 'Changes made here affect the entire Sentora configuration, please double check everything before saving changes.' WHERE `mo_id_pk` = '4';
UPDATE `zpanel_core`.`x_modules` SET `mo_desc_tx` = 'MySQL&reg; databases are used by many PHP applications such as forums and ecommerce systems, below you can manage and create MySQL&reg; databases.' WHERE `mo_id_pk` = '24';
UPDATE `zpanel_core`.`x_modules` SET `mo_updatever_vc` = NULL, `mo_updateurl_tx` = NULL WHERE `mo_id_pk` = '42';
UPDATE `zpanel_core`.`x_modules` SET `mo_desc_tx` = 'MySQL&reg; Users allows you to add users and permissions to your MySQL&reg; databases.' WHERE `mo_id_pk` = '39';
UPDATE `zpanel_core`.`x_modules` SET `mo_name_vc` = 'Sentora News', `mo_desc_tx` = 'Find out all the latest news and information from the Sentora project.' WHERE `mo_id_pk` = '5';
UPDATE `zpanel_core`.`x_modules` SET `mo_desc_tx` = 'phpMyAdmin is a web based tool that enables you to manage your Sentora MySQL databases via. the web.' WHERE `mo_id_pk` = '8';
DELETE FROM `zpanel_core`.`x_modules` WHERE `mo_id_pk` = '43';
INSERT INTO `zpanel_core`.`x_modules` (`mo_id_pk`, `mo_category_fk`, `mo_name_vc`, `mo_version_in`, `mo_folder_vc`, `mo_type_en`, `mo_desc_tx`, `mo_installed_ts`, `mo_enabled_en`, `mo_updatever_vc`, `mo_updateurl_tx`) VALUES('48', '3', 'Protected Directories', '200', 'protected_directories', 'user', 'Password protect your web applications and directories.', NULL, 'true', '', '');

INSERT INTO `zpanel_core`.`x_permissions` (`pe_id_pk`, `pe_group_fk`, `pe_module_fk`) VALUES('94', '3', '48');
INSERT INTO `zpanel_core`.`x_permissions` (`pe_id_pk`, `pe_group_fk`, `pe_module_fk`) VALUES('93', '2', '48');
INSERT INTO `zpanel_core`.`x_permissions` (`pe_id_pk`, `pe_group_fk`, `pe_module_fk`) VALUES('92', '1', '48');

UPDATE `zpanel_core`.`x_quotas` SET `qt_domains_in` = '-1', `qt_subdomains_in` = '-1', `qt_parkeddomains_in` = '-1', `qt_mailboxes_in` = '-1', `qt_fowarders_in` = '-1', `qt_distlists_in` = '-1', `qt_ftpaccounts_in` = '-1', `qt_mysql_in` = '-1', `qt_diskspace_bi` = '0', `qt_bandwidth_bi` = '0' WHERE `qt_id_pk` = '1';

UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '16';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '102';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL, `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '21';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '13';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Sentora version', `so_value_tx` = '1.0.3', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '6';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/panel/etc/static/', `so_desc_tx` = 'The Sentora static directory, used for storing welcome pages etc. etc.' WHERE `so_id_pk` = '75';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'trusted-servers' WHERE `so_id_pk` = '66';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '24';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '120';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '0' WHERE `so_id_pk` = '41';
UPDATE `zpanel_core`.`x_settings` SET `so_name_vc` = 'sentora_domain', `so_cleanname_vc` = 'Sentora Domain', `so_value_tx` = 'sentora.ztest.com', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '90';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '0' WHERE `so_id_pk` = '39';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '112';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/logs/bind/bind.log' WHERE `so_id_pk` = '68';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '113';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '35';
UPDATE `zpanel_core`.`x_settings` SET `so_desc_tx` = 'Allow users to change IP settings in A records. If set to false, IP is locked to server IP setting in Sentora Config' WHERE `so_id_pk` = '63';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'ScriptAlias /cgi-bin/ "/_cgi-bin/"^M
<location /cgi-bin>^M
AddHandler cgi-script .cgi .pl^M
Options +ExecCGI -Indexes^M
</location>' WHERE `so_id_pk` = '73';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/configs/apache/httpd-vhosts.conf' WHERE `so_id_pk` = '71';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'false' WHERE `so_id_pk` = '45';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Sentora News API URL', `so_value_tx` = 'http://api.sentora.org/latestnews.json', `so_desc_tx` = 'Sentora News URL', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '18';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '33';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '105';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'sentora_postfix' WHERE `so_id_pk` = '51';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'ee8795c8c53bfdb3b2cc595186b68912', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '28';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/configs/bind/etc/' WHERE `so_id_pk` = '56';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/panel/etc/static/parking/' WHERE `so_id_pk` = '76';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'Sentora Server', `so_desc_tx` = 'The name to appear in the From field of emails sent by Sentora.', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '30';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '117';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '26';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Cached version of latest sentora version', `so_value_tx` = '1.0.0', `so_desc_tx` = 'This is used for caching the latest version of Sentora.', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '25';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '107';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '32';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Global Sentora Entry', `so_desc_tx` = 'Extra directives for Sentora default vhost.' WHERE `so_id_pk` = '87';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '31';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/temp/', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '17';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/temp/' WHERE `so_id_pk` = '84';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/panel/bin/zsudo', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '99';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'no-ip,dyndns,autono,zphub' WHERE `so_id_pk` = '78';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Sentora Log file', `so_value_tx` = '/var/sentora/logs/sentora.log', `so_desc_tx` = 'If logging is set to 'file' mode this is the path to the log file that is to be used by Sentora.', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '27';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '64';
UPDATE `zpanel_core`.`x_settings` SET `so_desc_tx` = 'The root drive where Sentora is installed.', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '14';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'true' WHERE `so_id_pk` = '92';
UPDATE `zpanel_core`.`x_settings` SET `so_name_vc` = 'Sentora_df', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '10';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '115';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/hostdata/' WHERE `so_id_pk` = '69';
UPDATE `zpanel_core`.`x_settings` SET `so_desc_tx` = 'Cron time for when to run the Sentora daemon', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '104';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '101';
UPDATE `zpanel_core`.`x_settings` SET `so_name_vc` = 'sentora_root', `so_cleanname_vc` = 'Sentora root path', `so_value_tx` = '/etc/sentora/panel/', `so_desc_tx` = 'Sentora Web Root', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '7';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '119';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/logs/', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '91';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'sentora_proftpd' WHERE `so_id_pk` = '46';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config', `so_usereditable_en` = 'false' WHERE `so_id_pk` = '8';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/configs/bind/zones/' WHERE `so_id_pk` = '58';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Sentora Update API URL', `so_value_tx` = 'http://api.sentora.org/latestversion.json', `so_desc_tx` = 'Sentora Update URL', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '19';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = 'sentora@localhost', `so_desc_tx` = 'The email address to appear in the From field of emails sent by Sentora.', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '29';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = NULL WHERE `so_id_pk` = '65';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '37';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/temp/' WHERE `so_id_pk` = '79';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '22';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '36';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/etc/sentora/panel/bin/daemon.php', `so_desc_tx` = 'Path to the Sentora daemon', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '103';
UPDATE `zpanel_core`.`x_settings` SET `so_cleanname_vc` = 'Sentora Debug Mode', `so_value_tx` = 'prod', `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '114';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '0' WHERE `so_id_pk` = '40';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '0' WHERE `so_id_pk` = '38';
UPDATE `zpanel_core`.`x_settings` SET `so_module_vc` = 'Sentora Config' WHERE `so_id_pk` = '34';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '86400', `so_desc_tx` = 'Global expire TTL. Default = 86400 (1 day)' WHERE `so_id_pk` = '61';
UPDATE `zpanel_core`.`x_settings` SET `so_value_tx` = '/var/sentora/backups/' WHERE `so_id_pk` = '95';
DELETE FROM `zpanel_core`.`x_settings` WHERE `so_id_pk` = '106';
INSERT INTO `zpanel_core`.`x_settings` (`so_id_pk`, `so_name_vc`, `so_cleanname_vc`, `so_value_tx`, `so_defvalues_tx`, `so_desc_tx`, `so_module_vc`, `so_usereditable_en`) VALUES('121', 'sentora_port', 'Sentora Apache Port', '80', NULL, 'Sentora Apache panel port (change will be pending until next daemon run)', 'Sentora Config', 'true');


UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '67';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'Check to see if there are any available updates to your version of the Sentora software.', `tr_de_tx` = 'Prüfen Sie, ob es irgendwelche verfügbaren Aktualisierungen für Ihre Version des Sentora Software.' WHERE `tr_id_pk` = '97';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'Sentora News', `tr_de_tx` = 'Sentora Aktuelles' WHERE `tr_id_pk` = '72';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '120';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '112';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'Welcome to the Package Manager, using this module enables you to create and manage existing reseller packages on your Sentora hosting account.', `tr_de_tx` = 'Willkommen auf der Paket-Manager, mit diesem Modul ermöglicht Ihnen die Erstellung und Verwaltung von bestehenden Reseller-Pakete auf Ihrem Sentora Hosting-Account.' WHERE `tr_id_pk` = '111';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '113';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '121';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '44';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'Find out all the latest news and information from the Sentora project.', `tr_de_tx` = 'Finden Sie heraus, alle Neuigkeiten und Informationen aus dem Sentora Projekt.' WHERE `tr_id_pk` = '96';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '108';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '56';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '117';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '102';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '100';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '107';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '106';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '110';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'phpMyAdmin is a web based tool that enables you to manage your Sentora MySQL databases via. the web.', `tr_de_tx` = 'phpMyAdmin ist ein webbasiertes Tool, das Sie zu Ihrem Sentora MySQL-Datenbanken via verwalten können. im Internet.' WHERE `tr_id_pk` = '99';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'If you have found a bug with Sentora you can report it here.', `tr_de_tx` = 'Did you mean: If you have found a bug with CPanel you can report it here.^M
Wenn Sie einen Fehler mit Sentora gefunden haben, können Sie ihn hier melden.' WHERE `tr_id_pk` = '98';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '91';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '105';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '104';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '69';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '101';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'Sentora Config', `tr_de_tx` = 'Config Sentora' WHERE `tr_id_pk` = '71';
UPDATE `zpanel_core`.`x_translations` SET `tr_en_tx` = 'The backup manager module enables you to backup your entire hosting account including all your MySQL&reg; databases.', `tr_de_tx` = 'Der Backup-Manager-Modul ermöglicht es Ihnen, Ihre gesamte Hosting-Account inklusive aller Ihrer MySQL &reg; Datenbank-Backup.' WHERE `tr_id_pk` = '103';
UPDATE `zpanel_core`.`x_translations`  WHERE `tr_id_pk` = '114';


