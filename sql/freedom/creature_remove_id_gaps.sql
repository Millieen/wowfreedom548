START TRANSACTION;
-- Removes other table referenced GUID creatures.
TRUNCATE TABLE `world`.`pool_creature`;
TRUNCATE TABLE `world`.`game_event_creature`;
TRUNCATE TABLE `world`.`game_event_npc_vendor`;

-- Drop PRIMARY KEY temporarily, along with AUTO_INCREMENT
ALTER TABLE `world`.`creature` 
	CHANGE `guid` `guid` INT(10) UNSIGNED NOT NULL,
	DROP PRIMARY KEY;
	
-- Updates creature table to remove gaps between GUIDs
SET @GUID_GEN := 0;
UPDATE `world`.`creature` SET `guid` = @GUID_GEN:= @GUID_GEN + 1;

-- Re-add PRIMARY KEY and AUTO_INCREMENT
ALTER TABLE `world`.`creature`
	CHANGE `guid` `guid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	ADD PRIMARY KEY(`guid`);

-- Reset AUTO_INCREMENT
ALTER TABLE `world`.`creature` AUTO_INCREMENT = 1; 
COMMIT;