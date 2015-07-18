USE world;
ALTER TABLE `creature`
	ADD COLUMN `size` FLOAT NOT NULL DEFAULT '1' COMMENT 'In-game scale of the NPC' AFTER `dynamicflags`,
	ADD COLUMN `creator` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Creator of the NPC' AFTER `size`,
	ADD COLUMN `editor` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Last account what modified the NPC' AFTER `creator`,
	ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When NPC was first created/spawned' AFTER `editor`,
	ADD COLUMN `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When NPC was last modified' AFTER `created`;

UPDATE IGNORE creature SET size = (SELECT size FROM creature_template WHERE entry = creature.id);