USE `sentora_core`;

/* Update the sentora database version number */
/*UPDATE `x_settings` SET `so_value_tx` = '2.0.2' WHERE `so_name_vc` = 'dbversion';*/

/* Update the sentora Modules Cats */
UPDATE `x_modules` SET `mo_category_fk` = '3' WHERE `mo_name_vc` = 'PHPinfo';
UPDATE `x_modules` SET `mo_category_fk` = '7' WHERE `mo_name_vc` = 'Shadowing';
