<?php

/*
 +-----------------------------------------------------------------------+
 | Main configuration file                                               |
 |                                                                       |
 | This file is part of the Roundcube Webmail client                     |
 | Copyright (C) 2005-2013, The Roundcube Dev Team                       |
 |                                                                       |
 | Licensed under the GNU General Public License version 3 or            |
 | any later version with exceptions for skins & plugins.                |
 | See the README file for a full license statement.                     |
 +-----------------------------------------------------------------------+
*/

$config = array();

// ----------------------------------
// SQL DATABASE
// ----------------------------------

// Database connection string (DSN) for read+write operations
// Format (compatible with PEAR MDB2): db_provider://user:password@host/database
// Currently supported db_providers: mysql, pgsql, sqlite, mssql or sqlsrv
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// NOTE: for SQLite use absolute path: 'sqlite:////full/path/to/sqlite.db?mode=0646'
$config['db_dsnw'] = 'mysql://roundcube:!ROUNDCUBE_PASSWORD!@localhost/sentora_roundcube';
$config['db_table_users'] = 'users';
$config['db_table_identities'] = 'identities';
$config['db_table_contacts'] = 'contacts';
$config['db_table_contactgroups'] = 'contactgroups';
$config['db_table_contactgroupmembers'] = 'contactgroupmembers';
$config['db_table_session'] = 'session';
$config['db_table_cache'] = 'cache';
$config['db_table_cache_index'] = 'cache_index';
$config['db_table_cache_thread'] = 'cache_thread';
$config['db_table_cache_messages'] = 'cache_messages';

// ----------------------------------
// SMTP
// ----------------------------------
$config['smtp_server'] = 'localhost'; //Default was ''

// SMTP port for server
$config['smtp_port'] = 25; 

// SMTP AUTH Type
$config['smtp_auth_type'] = '';

// SMTP username (if required) if you use %u as the username Roundcube
// will use the current username for login
$config['smtp_user'] = '%u'; //Default was ''

// SMTP password (if required) if you use %p as the password Roundcube
// will use the current user's password for login
$config['smtp_pass'] = '%p'; //Default was ''

// use this folder to store log files (must be writeable for apache user)
// This is used by the 'file' log driver.
$config['log_dir'] = '/var/sentora/logs/roundcube/'; //Default was RCUBE_INSTALL_PATH . 'logs/'

// use this folder to store temp files (must be writeable for apache user)
$config['temp_dir'] = '/var/sentora/temp'; //Default was RCUBE_INSTALL_PATH . 'temp/'

// Forces conversion of logins to lower case.
// 0 - disabled, 1 - only domain part, 2 - domain and local part.
// If users authentication is case-insensitive this must be enabled.
// Note: After enabling it all user records need to be updated, e.g. with query:
//       UPDATE users SET username = LOWER(username);
$config['login_lc'] = 0; //Default was 2
// this key is used to encrypt the users imap password which is stored
// in the session record (and the client cookie if remember password is enabled).
// please provide a string of exactly 24 chars.
$config['des_key'] = '!ROUNDCUBE_DESKEY!';
// Name your service. This is displayed on the login screen and in the window title
$config['product_name'] = 'Sentora Webmail'; //Default was 'Roundcube Webmail'

// Path to a local mime magic database file for PHPs finfo extension.
// Set to null if the default path should be used.
#$config['mime_magic'] = '/usr/share/misc/magic'; //default was null

// ----------------------------------
// PLUGINS
// ----------------------------------

// List of active plugins (in plugins/ directory)
$config['plugins'] = array('managesieve');

// ----------------------------------
// USER INTERFACE
// ----------------------------------
// automatically create the above listed default folders on first login
$config['create_default_folders'] = true; //Default was false

// ----------------------------------
// USER PREFERENCES
// ----------------------------------

// display remote inline images
// 0 - Never, always ask
// 1 - Ask if sender is not in address book
// 2 - Always show inline images
$config['show_images'] = 2; //Default was 0

// compose html formatted messages by default
// 0 - never, 1 - always, 2 - on reply to HTML message, 3 - on forward or reply to HTML message
$config['htmleditor'] = 1; //Default was 0

// save compose message every 120 seconds (2min)
$config['draft_autosave'] = 120; //default was 300

// If true, after message delete/move, the next message will be displayed
$config['display_next'] = false; //Default was true