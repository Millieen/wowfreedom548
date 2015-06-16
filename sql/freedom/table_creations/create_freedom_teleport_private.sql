USE world;
CREATE TABLE `freedom_tele_private` (
	`id` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
	`position_x` FLOAT NOT NULL DEFAULT '0',
	`position_y` FLOAT NOT NULL DEFAULT '0',
	`position_z` FLOAT NOT NULL DEFAULT '0',
	`orientation` FLOAT NOT NULL DEFAULT '0',
	`map` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0',
	`name` VARCHAR(100) NOT NULL DEFAULT '',
	`gm_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'GM Account Identifier',
	`owner_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'OWNER Account Identifier',
	PRIMARY KEY (`id`)
)
COMMENT='.f pteleport table'
COLLATE='utf8_general_ci'
ENGINE=MyISAM
;