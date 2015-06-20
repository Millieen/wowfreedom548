USE `world`;
ALTER TABLE world.gameobject_template
	ADD COLUMN `disabled` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - disable object from lookup searches and disallow its spawning, 0 - enable gameobject and show in .lookup object, also allow its spawning' AFTER `WDBVerified`;
	