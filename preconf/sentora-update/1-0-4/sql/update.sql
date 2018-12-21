USE `sentora_core`;

/* Update the sentora database version number */
UPDATE `x_settings` SET `so_value_tx` = '1.0.4' WHERE `so_name_vc` = 'dbversion';

/* Expand DNS target for DKIM sizing */
ALTER TABLE `x_dns` CHANGE `dn_target_vc` `dn_target_vc` VARCHAR(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
