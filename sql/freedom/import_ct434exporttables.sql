-- Description: CT434 EXPORT TABLE IMPORTING INTO MP548 DB
-- P.S. Export tables must be loaded into `test` DB
-- P.S.S. Refer to this on what tables need to be exported: https://docs.google.com/spreadsheets/d/11sDBKNx-rTJphiZef37d7HtnIz9VOgGaPV1FiOiOvQo/
-- P.S.S.S. This import process does not include custom columns or custom tables, they will be handled separate SQL scripts.
USE test;

-- -- ------- -- --
-- -- AUTH DB -- --
-- -- ------- -- --

-- test.account => auth.account
START TRANSACTION;
DELETE FROM auth.account;
INSERT INTO auth.account (`id`, `username`, `sha_pass_hash`, `sessionkey`, `v`, `s`, `token_key`, `email`, `reg_mail`, `joindate`, `last_ip`, `failed_logins`, `locked`, `lock_country`, `last_login`, `online`, `expansion`, `mutetime`, `mutereason`, `muteby`, `locale`, `os`, `recruiter` )
SELECT 						  `id`, `username`, `sha_pass_hash`, `sessionkey`, `v`, `s`, `token_key`, `email`, `reg_mail`, `joindate`, `last_ip`, `failed_logins`, `locked`, `lock_country`, `last_login`, `online`, `expansion`, `mutetime`, `mutereason`, `muteby`, `locale`, `os`, `recruiter`
FROM 			test.account;
-- update expansion
UPDATE auth.account SET `expansion` = 4;
COMMIT;

-- test.account_access => auth.account_access
START TRANSACTION;
DELETE FROM auth.account_access;
INSERT INTO auth.account_access (`id`, `gmlevel`, `RealmID`)
SELECT 									`id`, `gmlevel`, `RealmID`
FROM			test.account_access;								  
COMMIT;

-- test.account_banned => auth.account_banned
START TRANSACTION;
DELETE FROM auth.account_banned;
INSERT INTO auth.account_banned (`id`, `bandate`, `unbandate`, `bannedby`, `banreason`, `active`)
SELECT 									`id`, `bandate`, `unbandate`, `bannedby`, `banreason`, `active`
FROM			test.account_banned;								  
COMMIT;

-- test.realmcharacters => auth.realmcharacters
START TRANSACTION;
DELETE FROM auth.realmcharacters;
INSERT INTO auth.realmcharacters (`realmid`, `acctid`, `numchars`)
SELECT 									 `realmid`, `acctid`, `numchars`
FROM			test.realmcharacters;								  
COMMIT;

-- -- -------- -- --
-- -- WORLD DB -- --
-- -- -------- -- --

-- test.gameobject => world.gameobject
START TRANSACTION;
-- Remove duplicate (same object in same place) entries from export gameobject table.
-- requires index at least on `id` column on world.gameobject
-- else it gets stuck/too slow of a query
-- therefore, temp index created and dropped after delete action
CREATE INDEX `temp` ON world.gameobject(`id`);
DELETE FROM a
USING test.gameobject AS a
WHERE EXISTS (
	SELECT 1 FROM world.gameobject b 
	WHERE a.id = b.id
	AND a.map = b.map
	AND a.position_x = b.position_x
	AND a.position_y = b.position_y
	AND a.position_z = b.position_z
);
DROP INDEX `temp` ON world.gameobject;

-- begin insertion
INSERT INTO world.gameobject (`id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `size`, `created`, `modified`)
SELECT 								`id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `size`, `creation_date`, `creation_date`
FROM			test.gameobject;

COMMIT;

-- test.creature => world.creature
START TRANSACTION;
-- Remove duplicate (same npc in same place) entries from export creature table.
-- already has bunch of indexes, no need to add temporary ones
DELETE FROM a
USING test.creature AS a
WHERE EXISTS (
	SELECT 1 FROM world.creature b 
	WHERE a.id = b.id
	AND a.map = b.map
	AND a.position_x = b.position_x
	AND a.position_y = b.position_y
	AND a.position_z = b.position_z
);
-- begin insertion
INSERT INTO world.creature (`id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `size`, `created`, `modified`)
SELECT 							 `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `size`, `creation_date`, `creation_date`
FROM			test.creature;
COMMIT;

-- test.playercreateinfo_spell_custom => world.playercreateinfo_spell_custom
START TRANSACTION;
DELETE FROM world.playercreateinfo_spell_custom;
INSERT INTO world.playercreateinfo_spell_custom (`racemask`, `classmask`, `Spell`, `Note`)
SELECT 									 					 `racemask`, `classmask`, `Spell`, `Note`
FROM			test.playercreateinfo_spell_custom;								  
COMMIT;

-- test.freedom_morphs => world.freedom_morph
START TRANSACTION;
DELETE FROM world.freedom_morph;
-- convert gmAcc name to gm's account id
ALTER TABLE test.freedom_morphs ADD COLUMN `gm_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0';
UPDATE test.freedom_morphs SET `gm_uid` = (SELECT id FROM test.account WHERE username = gmAcc);

INSERT INTO world.freedom_morph (`guid`, `name`, `display_id`, `gm_uid`)
SELECT 									`charGUID`, `morphName`, `morphId`, `gm_uid`
FROM			test.freedom_morphs;	
ALTER TABLE test.freedom_morphs DROP COLUMN `gm_uid`;							  
COMMIT;

-- test.freedom_tele => world.freedom_tele
START TRANSACTION;
DELETE FROM world.freedom_tele;
-- convert gmAcc name to gm's account id
ALTER TABLE test.freedom_tele ADD COLUMN `gm_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0';
UPDATE test.freedom_tele SET `gm_uid` = (SELECT id FROM test.account WHERE username = gmAcc);

INSERT INTO world.freedom_tele (`id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`, `gm_uid`)
SELECT 								  `id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`, `gm_uid`
FROM			test.freedom_tele;	
ALTER TABLE test.freedom_tele DROP COLUMN `gm_uid`;							  
COMMIT;

-- test.freedom_private_tele => world.freedom_tele_private
START TRANSACTION;
DELETE FROM world.freedom_tele_private;
-- convert gmAcc name to gm's account id
ALTER TABLE test.freedom_private_tele ADD COLUMN `gm_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE test.freedom_private_tele ADD COLUMN `owner_uid` INT(10) UNSIGNED NOT NULL DEFAULT '0';
UPDATE test.freedom_private_tele SET `gm_uid` = (SELECT id FROM test.account WHERE username = gmAcc);
UPDATE test.freedom_private_tele SET `owner_uid` = (SELECT id FROM test.account WHERE username = ownerAcc);

INSERT INTO world.freedom_tele_private (`id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`, `gm_uid`, `owner_uid`)
SELECT 								  			 `id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`, `gm_uid`, `owner_uid`
FROM			test.freedom_private_tele;	
ALTER TABLE test.freedom_private_tele DROP COLUMN `gm_uid`;
ALTER TABLE test.freedom_private_tele DROP COLUMN `owner_uid`;							  
COMMIT;

-- -- ------------- -- --
-- -- CHARACTERS DB -- --
-- -- ------------- -- --

-- test.characters => characters.characters
START TRANSACTION;
DELETE FROM characters.characters;
INSERT INTO characters.characters (`guid`, `account`, `name`, `slot`, `race`, `class`, `gender`, `level`, `xp`, `money`, `playerBytes`, `playerBytes2`, `playerFlags`, `position_x`, `position_y`, `position_z`, `map`, `instance_id`, `instance_mode_mask`, `orientation`, `taximask`, `online`, `cinematic`, `totaltime`, `leveltime`, `logout_time`, `is_logout_resting`, `rest_bonus`, `resettalents_cost`, `resettalents_time`, `talentTree`, `trans_x`, `trans_y`, `trans_z`, `trans_o`, `transguid`, `extra_flags`, `stable_slots`, `at_login`, `zone`, `death_expire_time`, `taxi_path`, `totalKills`, `todayKills`, `yesterdayKills`, `chosenTitle`, `watchedFaction`, `drunk`, `health`, `power1`, `power2`, `power3`, `power4`, `power5`, `latency`, `speccount`, `activespec`, `exploredZones`, `equipmentCache`, `knownTitles`, `actionBars`, `grantableLevels`, `deleteInfos_Account`, `deleteInfos_Name`, `deleteDate`)
SELECT 									  `guid`, `account`, `name`, `slot`, `race`, `class`, `gender`, `level`, `xp`, `money`, `playerBytes`, `playerBytes2`, `playerFlags`, `position_x`, `position_y`, `position_z`, `map`, `instance_id`, `instance_mode_mask`, `orientation`, `taximask`, `online`, `cinematic`, `totaltime`, `leveltime`, `logout_time`, `is_logout_resting`, `rest_bonus`, `resettalents_cost`, `resettalents_time`, `talentTree`, `trans_x`, `trans_y`, `trans_z`, `trans_o`, `transguid`, `extra_flags`, `stable_slots`, `at_login`, `zone`, `death_expire_time`, `taxi_path`, `totalKills`, `todayKills`, `yesterdayKills`, `chosenTitle`, `watchedFaction`, `drunk`, `health`, `power1`, `power2`, `power3`, `power4`, `power5`, `latency`, `speccount`, `activespec`, `exploredZones`, `equipmentCache`, `knownTitles`, `actionBars`, `grantableLevels`, `deleteInfos_Account`, `deleteInfos_Name`, `deleteDate`
FROM			test.characters;
UPDATE characters.characters SET `level` = 90;								  
COMMIT;

-- test.character_currency => characters.character_currency
START TRANSACTION;
DELETE FROM characters.character_currency;
INSERT INTO characters.character_currency (`guid`, `currency`, `total_count`, `week_count`)
SELECT 									 			 `guid`, `currency`, `total_count`, `week_count`
FROM			test.character_currency;								  
COMMIT;

-- test.character_inventory => characters.character_inventory
START TRANSACTION;
DELETE FROM characters.character_inventory;
INSERT INTO characters.character_inventory (`guid`, `bag`, `slot`, `item`)
SELECT 									 			  `guid`, `bag`, `slot`, `item`
FROM			test.character_inventory;								  
COMMIT;

-- test.character_pet => characters.character_pet
START TRANSACTION;
DELETE FROM characters.character_pet;
INSERT INTO characters.character_pet (`id`, `entry`, `owner`, `modelid`, `CreatedBySpell`, `PetType`, `level`, `exp`, `Reactstate`, `name`, `renamed`, `slot`, `curhealth`, `curmana`, `savetime`, `abdata`)
SELECT 									 	  `id`, `entry`, `owner`, `modelid`, `CreatedBySpell`, `PetType`, `level`, `exp`, `Reactstate`, `name`, `renamed`, `slot`, `curhealth`, `curmana`, `savetime`, `abdata`
FROM			test.character_pet;								  
COMMIT;

-- test.character_skills => characters.character_skills
START TRANSACTION;
DELETE FROM characters.character_skills;
INSERT INTO characters.character_skills (`guid`, `skill`, `value`, `max`)
SELECT 									 	  	  `guid`, `skill`, `value`, `max`
FROM			test.character_skills;								  
COMMIT;

-- test.character_social => characters.character_social
START TRANSACTION;
DELETE FROM characters.character_social;
INSERT INTO characters.character_social (`guid`, `friend`, `flags`, `note`)
SELECT 									 	  	  `guid`, `friend`, `flags`, `note`
FROM			test.character_social;								  
COMMIT;

-- test.character_spell => characters.character_spell
START TRANSACTION;
DELETE FROM characters.character_spell;
INSERT INTO characters.character_spell (`guid`, `spell`, `active`, `disabled`)
SELECT 									 	  	 `guid`, `spell`, `active`, `disabled`
FROM			test.character_spell;								  
COMMIT;

-- test.gm_tickets => characters.gm_tickets
START TRANSACTION;
DELETE FROM characters.gm_tickets;
INSERT INTO characters.gm_tickets (`ticketId`, `guid`, `name`, `message`, `createTime`, `mapId`, `posX`, `posY`, `posZ`, `lastModifiedTime`, `closedBy`, `assignedTo`, `comment`, `response`, `completed`, `escalated`, `viewed`, `haveTicket`)
SELECT 									  `ticketId`, `guid`, `name`, `message`, `createTime`, `mapId`, `posX`, `posY`, `posZ`, `lastModifiedTime`, `closedBy`, `assignedTo`, `comment`, `response`, `completed`, `escalated`, `viewed`, `haveTicket`
FROM			test.gm_tickets;								  
COMMIT;

-- test.item_instance => characters.item_instance
START TRANSACTION;
DELETE FROM characters.item_instance;
INSERT INTO characters.item_instance (`guid`, `itemEntry`, `owner_guid`, `creatorGuid`, `giftCreatorGuid`, `count`, `duration`, `charges`, `flags`, `enchantments`, `randomPropertyId`, `durability`, `playedTime`, `text`)
SELECT 									  	  `guid`, `itemEntry`, `owner_guid`, `creatorGuid`, `giftCreatorGuid`, `count`, `duration`, `charges`, `flags`, `enchantments`, `randomPropertyId`, `durability`, `playedTime`, `text`
FROM			test.item_instance;								  
COMMIT;

-- test.item_loot_items => characters.item_loot_items
START TRANSACTION;
DELETE FROM characters.item_loot_items;
INSERT INTO characters.item_loot_items (`container_id`, `item_id`, `item_count`, `follow_rules`, `ffa`, `blocked`, `counted`, `under_threshold`, `needs_quest`, `rnd_prop`, `rnd_suffix`)
SELECT 									  	  	 `container_id`, `item_id`, `item_count`, `follow_rules`, `ffa`, `blocked`, `counted`, `under_threshold`, `needs_quest`, `rnd_prop`, `rnd_suffix`
FROM			test.item_loot_items;								  
COMMIT;

-- test.pet_spell => characters.pet_spell
START TRANSACTION;
DELETE FROM characters.pet_spell;
INSERT INTO characters.pet_spell (`guid`, `spell`, `active`)
SELECT 									 `guid`, `spell`, `active`
FROM			test.pet_spell;								  
COMMIT;