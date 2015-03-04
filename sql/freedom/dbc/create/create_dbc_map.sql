CREATE TABLE `dbc_map` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`directory` VARCHAR(255) NOT NULL,
	`type` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '1 = Instance, 2 = Raid, 3 = BG, 4 = Arena, 5 = Scenario',
	`Flags` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`PVP` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`MapName` VARCHAR(255) NOT NULL DEFAULT '0',
	`areaTableID` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`MapDescription0` TEXT NULL COMMENT 'Alliance',
	`MapDescription1` TEXT NULL COMMENT 'Horde',
	`LoadingScreenID` INT(11) NOT NULL DEFAULT '0' COMMENT 'LoadingScreens.dbc',
	`minimapIconScale` FLOAT NOT NULL DEFAULT '0',
	`corpseMapID` INT(11) NOT NULL DEFAULT '0' COMMENT 'map_id of entrance map in ghost mode (continent always and in most cases = normal entrance)',
	`corpseX` FLOAT NOT NULL DEFAULT '0',
	`corpseY` FLOAT NOT NULL DEFAULT '0',
	`timeOfDayOverride` INT(11) NOT NULL DEFAULT '0',
	`expansionID` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`raidOffset` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`maxPlayers` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`rootPhaseMap` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `idx_name` (`MapName`)
)
COMMENT='Used for game object patch'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
