USE `world`;
ALTER TABLE world.creature_template
	ADD COLUMN `disabled` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - disable NPC from lookup searches and disallow its spawning, 0 - enable NPC and show in .lookup creature, also allow its spawning' AFTER `WDBVerified`;
	