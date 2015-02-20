ALTER TABLE `gameobject`ADD COLUMN `size` FLOAT NOT NULL DEFAULT '1' AFTER `state`;
UPDATE gameobject SET size = (SELECT size FROM gameobject_template WHERE entry = gameobject.id);
ALTER TABLE `gameobject` ADD COLUMN `owner` VARCHAR(32) NOT NULL DEFAULT '' AFTER `size`;
ALTER TABLE `gameobject` ADD COLUMN `editor` VARCHAR(32) NOT NULL DEFAULT '' AFTER `owner`;
ALTER TABLE `gameobject` ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `editor`;
ALTER TABLE `gameobject` ADD COLUMN `lookup` BOOLEAN NOT NULL DEFAULT TRUE AFTER `created`;
