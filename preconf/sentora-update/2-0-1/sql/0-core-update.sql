USE `sentora_core`;

/* Update the sentora database version number */
UPDATE `x_settings` SET `so_value_tx` = '2.0.1' WHERE `so_name_vc` = 'dbversion';