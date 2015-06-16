-- adds column 'public', used to determine if item is available in .freedom item $itemId command

START TRANSACTION;

ALTER TABLE `world`.`item_template` ADD COLUMN `public` BOOL NOT NULL DEFAULT FALSE AFTER `WDBVerified`;

COMMIT;