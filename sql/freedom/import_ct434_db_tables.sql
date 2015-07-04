-- [MoP TESTING PHASE script]
-- script to import some cataclysm tables, much like import_ct434exporttables.sql file,
-- except that this is launched when MoP and Cata databases are on the same MySQL instance
-- due to direct access to each-other's tables

-- -- ------- -- --
-- -- AUTH DB -- --
-- -- ------- -- --

-- cata_auth.account => auth.account
START TRANSACTION;
REPLACE INTO auth.account (`id`, `web_user_id`, `username`, `sha_pass_hash`, `sessionkey`, `v`, `s`, `token_key`, `email`, `reg_mail`, `joindate`, `last_ip`, `failed_logins`, `locked`, `lock_country`, `last_login`, `online`, `expansion`, `mutetime`, `mutereason`, `muteby`, `locale`, `os`, `recruiter` )
SELECT 						   `id`, `web_user_id`, `username`, `sha_pass_hash`, `sessionkey`, `v`, `s`, `token_key`, `email`, `reg_mail`, `joindate`, `last_ip`, `failed_logins`, `locked`, `lock_country`, `last_login`, `online`, `expansion`, `mutetime`, `mutereason`, `muteby`, `locale`, `os`, `recruiter`
FROM 			cata_auth.account;
-- update expansion
UPDATE auth.account SET `expansion` = 4;
COMMIT;

-- cata_auth.account_access => auth.account_access
START TRANSACTION;
REPLACE INTO auth.account_access (`id`, `gmlevel`, `RealmID`)
SELECT 									 `id`, `gmlevel`, `RealmID`
FROM			cata_auth.account_access;								  
COMMIT;

-- cata_auth.account_banned => auth.account_banned
START TRANSACTION;
REPLACE INTO auth.account_banned (`id`, `bandate`, `unbandate`, `bannedby`, `banreason`, `active`)
SELECT 									 `id`, `bandate`, `unbandate`, `bannedby`, `banreason`, `active`
FROM			cata_auth.account_banned;								  
COMMIT;

-- cata_auth.realmcharacters => auth.realmcharacters
START TRANSACTION;
REPLACE INTO auth.realmcharacters (`realmid`, `acctid`, `numchars`)
SELECT 									  `realmid`, `acctid`, `numchars`
FROM			cata_auth.realmcharacters;								  
COMMIT;

-- -- ------------- -- --
-- -- CHARACTERS DB -- --
-- -- ------------- -- --

-- cata_characters.characters => characters.characters
START TRANSACTION;
DELETE FROM characters.characters;
INSERT INTO characters.characters (`guid`, `account`, `name`, `slot`, `race`, `class`, `gender`, `level`, `xp`, `money`, `playerBytes`, `playerBytes2`, `playerFlags`, `position_x`, `position_y`, `position_z`, `map`, `instance_id`, `instance_mode_mask`, `orientation`, `taximask`, `online`, `cinematic`, `totaltime`, `leveltime`, `logout_time`, `is_logout_resting`, `rest_bonus`, `resettalents_cost`, `resettalents_time`, `talentTree`, `trans_x`, `trans_y`, `trans_z`, `trans_o`, `transguid`, `extra_flags`, `stable_slots`, `at_login`, `zone`, `death_expire_time`, `taxi_path`, `totalKills`, `todayKills`, `yesterdayKills`, `chosenTitle`, `watchedFaction`, `drunk`, `health`, `power1`, `power2`, `power3`, `power4`, `power5`, `latency`, `speccount`, `activespec`, `exploredZones`, `equipmentCache`, `knownTitles`, `actionBars`, `grantableLevels`, `deleteInfos_Account`, `deleteInfos_Name`, `deleteDate`)
SELECT 									  `guid`, `account`, `name`, `slot`, `race`, `class`, `gender`, `level`, `xp`, `money`, `playerBytes`, `playerBytes2`, `playerFlags`, `position_x`, `position_y`, `position_z`, `map`, `instance_id`, `instance_mode_mask`, `orientation`, `taximask`, `online`, `cinematic`, `totaltime`, `leveltime`, `logout_time`, `is_logout_resting`, `rest_bonus`, `resettalents_cost`, `resettalents_time`, `talentTree`, `trans_x`, `trans_y`, `trans_z`, `trans_o`, `transguid`, `extra_flags`, `stable_slots`, `at_login`, `zone`, `death_expire_time`, `taxi_path`, `totalKills`, `todayKills`, `yesterdayKills`, `chosenTitle`, `watchedFaction`, `drunk`, `health`, `power1`, `power2`, `power3`, `power4`, `power5`, `latency`, `speccount`, `activespec`, `exploredZones`, `equipmentCache`, `knownTitles`, `actionBars`, `grantableLevels`, `deleteInfos_Account`, `deleteInfos_Name`, `deleteDate`
FROM			cata_characters.characters;
-- UPDATE MoP CHAR LEVEL
UPDATE characters.characters SET `level` = 90;								  
COMMIT;

-- cata_characters.character_currency => characters.character_currency
START TRANSACTION;
DELETE FROM characters.character_currency;
INSERT INTO characters.character_currency (`guid`, `currency`, `total_count`, `week_count`)
SELECT 									 			 `guid`, `currency`, `total_count`, `week_count`
FROM			cata_characters.character_currency;								  
COMMIT;

-- cata_characters.character_inventory => characters.character_inventory
START TRANSACTION;
DELETE FROM characters.character_inventory;
INSERT INTO characters.character_inventory (`guid`, `bag`, `slot`, `item`)
SELECT 									 			  `guid`, `bag`, `slot`, `item`
FROM			cata_characters.character_inventory;								  
COMMIT;

-- cata_characters.character_pet => characters.character_pet
START TRANSACTION;
DELETE FROM characters.character_pet;
INSERT INTO characters.character_pet (`id`, `entry`, `owner`, `modelid`, `CreatedBySpell`, `PetType`, `level`, `exp`, `Reactstate`, `name`, `renamed`, `slot`, `curhealth`, `curmana`, `savetime`, `abdata`)
SELECT 									 	  `id`, `entry`, `owner`, `modelid`, `CreatedBySpell`, `PetType`, `level`, `exp`, `Reactstate`, `name`, `renamed`, `slot`, `curhealth`, `curmana`, `savetime`, `abdata`
FROM			cata_characters.character_pet;								  
COMMIT;

-- cata_characters.character_skills => characters.character_skills
START TRANSACTION;
DELETE FROM characters.character_skills;
INSERT INTO characters.character_skills (`guid`, `skill`, `value`, `max`)
SELECT 									 	  	  `guid`, `skill`, `value`, `max`
FROM			cata_characters.character_skills;								  
COMMIT;

-- cata_characters.character_social => characters.character_social
START TRANSACTION;
DELETE FROM characters.character_social;
INSERT INTO characters.character_social (`guid`, `friend`, `flags`, `note`)
SELECT 									 	  	  `guid`, `friend`, `flags`, `note`
FROM			cata_characters.character_social;								  
COMMIT;

-- cata_characters.character_spell => characters.character_spell
START TRANSACTION;
DELETE FROM characters.character_spell;
INSERT INTO characters.character_spell (`guid`, `spell`, `active`, `disabled`)
SELECT 									 	  	 `guid`, `spell`, `active`, `disabled`
FROM			cata_characters.character_spell;								  
COMMIT;

-- cata_characters.gm_tickets => characters.gm_tickets
START TRANSACTION;
DELETE FROM characters.gm_tickets;
INSERT INTO characters.gm_tickets (`ticketId`, `guid`, `name`, `message`, `createTime`, `mapId`, `posX`, `posY`, `posZ`, `lastModifiedTime`, `closedBy`, `assignedTo`, `comment`, `response`, `completed`, `escalated`, `viewed`, `haveTicket`)
SELECT 									  `ticketId`, `guid`, `name`, `message`, `createTime`, `mapId`, `posX`, `posY`, `posZ`, `lastModifiedTime`, `closedBy`, `assignedTo`, `comment`, `response`, `completed`, `escalated`, `viewed`, `haveTicket`
FROM			cata_characters.gm_tickets;								  
COMMIT;

-- cata_characters.item_instance => characters.item_instance
START TRANSACTION;
DELETE FROM characters.item_instance;
INSERT INTO characters.item_instance (`guid`, `itemEntry`, `owner_guid`, `creatorGuid`, `giftCreatorGuid`, `count`, `duration`, `charges`, `flags`, `enchantments`, `randomPropertyId`, `durability`, `playedTime`, `text`)
SELECT 									  	  `guid`, `itemEntry`, `owner_guid`, `creatorGuid`, `giftCreatorGuid`, `count`, `duration`, `charges`, `flags`, `enchantments`, `randomPropertyId`, `durability`, `playedTime`, `text`
FROM			cata_characters.item_instance;								  
COMMIT;

-- cata_characters.item_loot_items => characters.item_loot_items
START TRANSACTION;
DELETE FROM characters.item_loot_items;
INSERT INTO characters.item_loot_items (`container_id`, `item_id`, `item_count`, `follow_rules`, `ffa`, `blocked`, `counted`, `under_threshold`, `needs_quest`, `rnd_prop`, `rnd_suffix`)
SELECT 									  	  	 `container_id`, `item_id`, `item_count`, `follow_rules`, `ffa`, `blocked`, `counted`, `under_threshold`, `needs_quest`, `rnd_prop`, `rnd_suffix`
FROM			cata_characters.item_loot_items;								  
COMMIT;

-- cata_characters.pet_spell => characters.pet_spell
START TRANSACTION;
DELETE FROM characters.pet_spell;
INSERT INTO characters.pet_spell (`guid`, `spell`, `active`)
SELECT 									 `guid`, `spell`, `active`
FROM			cata_characters.pet_spell;								  
COMMIT;

-- -- -------- -- --
-- -- WORLD DB -- --
-- -- -------- -- --

-- cata_world.gameobject => world.gameobject
START TRANSACTION;
-- set GUID offset for cata's GOs to insert into MoP
SET @GO_OFFSET := 4294967295;

-- begin insertion
INSERT INTO world.gameobject (`id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `size`, `created`, `modified`)
SELECT 								`id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `size`, `creation_date`, `creation_date`
FROM			cata_world.gameobject a
WHERE       a.guid >= @GO_OFFSET;

COMMIT;

-- cata_world.creature => world.creature
START TRANSACTION;
-- set GUID offset for cata's NPCs to insert into MoP
SET @NPC_OFFSET := 4294967295;

-- begin insertion
INSERT INTO world.creature (`id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `size`, `created`, `modified`)
SELECT 							 `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `size`, `creation_date`, `creation_date`
FROM			cata_world.creature a
WHERE       a.guid >= @NPC_OFFSET;
COMMIT;

-- cata_world.playercreateinfo_spell_custom => world.playercreateinfo_spell_custom
START TRANSACTION;
REPLACE INTO world.playercreateinfo_spell_custom (`racemask`, `classmask`, `Spell`, `Note`)
SELECT 									 					  `racemask`, `classmask`, `Spell`, `Note`
FROM			cata_world.playercreateinfo_spell_custom;								  
COMMIT;

-- cata_world.playercreateinfo_skills => world.playercreateinfo_skill_custom
START TRANSACTION;
REPLACE INTO world.playercreateinfo_skill_custom (`racemask`, `classmask`, `skill`, `rank`, `comment`)
SELECT 									 					  `racemask`, `classmask`, `skill`, `rank`, `comment`
FROM			cata_world.playercreateinfo_skills;								  
COMMIT;

