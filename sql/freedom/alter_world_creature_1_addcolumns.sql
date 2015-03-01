USE world;
ALTER TABLE `creature`ADD COLUMN `size` FLOAT NOT NULL DEFAULT '1' AFTER `dynamicflags`;
UPDATE IGNORE creature SET size = (SELECT size FROM creature_template WHERE entry = creature.id);
ALTER TABLE `creature` ADD COLUMN `owner` VARCHAR(32) NOT NULL DEFAULT '' AFTER `size`;
ALTER TABLE `creature` ADD COLUMN `editor` VARCHAR(32) NOT NULL DEFAULT '' AFTER `owner`;
ALTER TABLE `creature` ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `editor`;