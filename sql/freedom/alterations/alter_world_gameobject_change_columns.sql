USE `world`;
ALTER TABLE `gameobject`
	ADD COLUMN `size` FLOAT NOT NULL DEFAULT '1' COMMENT 'In-game scale of the object' AFTER `state`,
	ADD COLUMN `creator` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Creator of the game object' AFTER `size`,
	ADD COLUMN `editor` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Last account what modified the object' AFTER `owner`,
	ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When object was first created/spawned' AFTER `editor`,
	ADD COLUMN `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When object was last modified (moved, turned, scaled)' AFTER `created`;
	
UPDATE gameobject SET size = (SELECT size FROM gameobject_template WHERE entry = gameobject.id);