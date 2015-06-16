USE world;
DROP TABLE IF EXISTS `freedom_morph`;
CREATE TABLE `freedom_morph` (
	`guid` MEDIUMINT(8) UNSIGNED NOT NULL COMMENT 'CHARACTER identifier',
	`name` VARCHAR(100) NOT NULL COMMENT 'Custom given name for morph',
	`display_id` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0',
	`gm_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'GM Account Identifier',
)
COMMENT='.f morph table'
COLLATE='utf8_general_ci'
ENGINE=MyISAM
;