ALTER TABLE `world`.`item_template` 
	ADD COLUMN `public` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Used to determine if item is available in .freedom item $itemId command' AFTER `WDBVerified`;