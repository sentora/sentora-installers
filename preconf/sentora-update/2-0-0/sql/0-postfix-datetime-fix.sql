-- save current setting of sql_mode
SET @old_sql_mode := @@sql_mode ;

-- derive a new value by removing NO_ZERO_DATE and NO_ZERO_IN_DATE
SET @new_sql_mode := @old_sql_mode ;
SET @new_sql_mode := TRIM(BOTH ',' FROM REPLACE(CONCAT(',',@new_sql_mode,','),',NO_ZERO_DATE,'  ,','));
SET @new_sql_mode := TRIM(BOTH ',' FROM REPLACE(CONCAT(',',@new_sql_mode,','),',NO_ZERO_IN_DATE,',','));
SET @@sql_mode := @new_sql_mode ;

USE `sentora_postfix`;

ALTER TABLE admin MODIFY COLUMN created datetime DEFAULT NULL;
ALTER TABLE admin MODIFY COLUMN modified datetime DEFAULT NULL;
UPDATE admin set created=NULL WHERE modified='0000-00-00 00:00:00';
UPDATE admin set modified=NULL WHERE modified='0000-00-00 00:00:00';

ALTER TABLE alias MODIFY COLUMN created datetime DEFAULT NULL;
ALTER TABLE alias MODIFY COLUMN modified datetime DEFAULT NULL;
UPDATE alias set created=NULL WHERE modified='0000-00-00 00:00:00';
UPDATE alias set modified=NULL WHERE modified='0000-00-00 00:00:00';

ALTER TABLE alias_domain MODIFY COLUMN created datetime DEFAULT NULL;
ALTER TABLE alias_domain MODIFY COLUMN modified datetime DEFAULT NULL;
UPDATE alias_domain set created=NULL WHERE modified='0000-00-00 00:00:00';
UPDATE alias_domain set modified=NULL WHERE modified='0000-00-00 00:00:00';

ALTER TABLE domain MODIFY COLUMN created datetime DEFAULT NULL;
ALTER TABLE domain MODIFY COLUMN modified datetime DEFAULT NULL;
UPDATE domain set created=NULL WHERE modified='0000-00-00 00:00:00';
UPDATE domain set modified=NULL WHERE modified='0000-00-00 00:00:00';

ALTER TABLE mailbox MODIFY COLUMN created datetime DEFAULT NULL;
ALTER TABLE mailbox MODIFY COLUMN modified datetime DEFAULT NULL;
UPDATE mailbox set created=NULL WHERE modified='0000-00-00 00:00:00';
UPDATE mailbox set modified=NULL WHERE modified='0000-00-00 00:00:00';

ALTER TABLE vacation MODIFY COLUMN created datetime DEFAULT NULL;
UPDATE vacation set created=NULL WHERE created='0000-00-00 00:00:00';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
