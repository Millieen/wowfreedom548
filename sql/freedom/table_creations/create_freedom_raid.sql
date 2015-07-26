CREATE TABLE `freedom_raid` (
	`leader_guid` INT(10) UNSIGNED NOT NULL COMMENT 'Raid\'s unique identifier - guid of leader player',
	`member_guid` INT(10) UNSIGNED NOT NULL COMMENT 'Raid\'s member player guid',
	`subgroup` VARCHAR(255) NOT NULL DEFAULT 'MAIN' COMMENT 'Raid\'s party identifier. Raid can have multiple parties.',
	`assistant` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`leader_guid`, `member_guid`),
	INDEX `SUBGROUP INDX` (`subgroup`),
	INDEX `ASSISTANT INDX` (`assistant`)
)
COMMENT='Freedom command-invoked raid/party system.'
ENGINE=InnoDB
;