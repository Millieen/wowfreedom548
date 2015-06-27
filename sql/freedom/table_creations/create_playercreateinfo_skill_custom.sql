CREATE TABLE `playercreateinfo_skill_custom` (
	`raceMask` INT(10) UNSIGNED NOT NULL,
	`classMask` INT(10) UNSIGNED NOT NULL,
	`skill` SMALLINT(5) UNSIGNED NOT NULL,
	`rank` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0',
	`comment` VARCHAR(255) NULL DEFAULT NULL,
	PRIMARY KEY (`raceMask`, `classMask`, `skill`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
