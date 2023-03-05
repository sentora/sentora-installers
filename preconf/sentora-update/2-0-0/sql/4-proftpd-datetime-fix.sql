-- save current setting of sql_mode
SET @old_sql_mode := @@sql_mode ;

-- derive a new value by removing NO_ZERO_DATE and NO_ZERO_IN_DATE
SET @new_sql_mode := @old_sql_mode ;
SET @new_sql_mode := TRIM(BOTH ',' FROM REPLACE(CONCAT(',',@new_sql_mode,','),',NO_ZERO_DATE,'  ,','));
SET @new_sql_mode := TRIM(BOTH ',' FROM REPLACE(CONCAT(',',@new_sql_mode,','),',NO_ZERO_IN_DATE,',','));
SET @@sql_mode := @new_sql_mode ;

USE `sentora_proftpd`;

/* Update/fix ALL Proftpd ftpuser table with users w/modified 0000-00-00 00:00:00 value TO NULL for NO_ZREO_DATE & NO_ZERO_IN_DATE issues*/

ALTER TABLE ftpuser MODIFY COLUMN accessed datetime DEFAULT NULL;
ALTER TABLE ftpuser MODIFY COLUMN modified datetime DEFAULT NULL;

UPDATE ftpuser set modified=NULL WHERE modified='0000-00-00 00:00:00';


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
