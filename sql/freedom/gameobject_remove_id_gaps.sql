-- Description: Refines gameobject table to remove gaps between GUIDs, thus, decreasing max GUID value.

START TRANSACTION;
-- Removes other table referenced GUID gameobjects.
TRUNCATE TABLE `world`.`pool_gameobject`;
TRUNCATE TABLE `world`.`game_event_gameobject`;

-- Drop PRIMARY KEY temporarily, along with AUTO_INCREMENT
ALTER TABLE `world`.`gameobject` 
	CHANGE `guid` `guid` INT(10) UNSIGNED NOT NULL,
	DROP PRIMARY KEY;
	
-- Updates gameobject table to remove gaps between GUIDs
SET @count = 0;
UPDATE `world`.`gameobject` SET `guid` = @count:= @count + 1;

-- Re-add PRIMARY KEY and AUTO_INCREMENT
ALTER TABLE `world`.`gameobject`
	CHANGE `guid` `guid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	ADD PRIMARY KEY(`guid`);

-- Reset AUTO_INCREMENT
ALTER TABLE `world`.`gameobject` AUTO_INCREMENT = 1; 
COMMIT;