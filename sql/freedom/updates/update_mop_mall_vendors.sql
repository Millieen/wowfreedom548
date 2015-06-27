USE `world`;
START TRANSACTION;

SET @ENTRY_OFFSET_START := 90000;
SET @ENTRY_OFFSET_END   := 99999;
SET @WDBVERIFIED := 29000; -- will be used to identify mall vendor creature template entries

SET @M1 := 28694;
SET @M2 := 28561;
SET @M3 := 28842;
SET @M4 := 28892;
SET @FACTION := 35; -- friendly faction
SET @NPC_FLAG := 128;

DELETE FROM `npc_vendor` WHERE `entry` BETWEEN @ENTRY_OFFSET_START AND @ENTRY_OFFSET_END;
DELETE FROM `creature_template` WHERE `entry` BETWEEN @ENTRY_OFFSET_START AND @ENTRY_OFFSET_END;

-- Prepare temporary variables for mass-insertion
SET @ENTRY_GEN_HEAD := @ENTRY_OFFSET_START;

CREATE TEMPORARY TABLE `temp_mall_data` (
	`number` INT
);
INSERT INTO `temp_mall_data` (`number`) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25);

-- BEGIN INSERTION
-- Consumables [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Consumables ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (0) AND `subclass` IN (0) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- Consumables [ END ]

-- PEFS (Potions, Elixirs, Flasks, Scrolls) [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('PEFS ', `number`), 'Potions, Elixirs, Flasks, Scrolls', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (0) AND `subclass` IN (1,2,3,4) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- PEFS [ END ]

-- Food & Drinks [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Food & Drinks ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (0) AND `subclass` IN (5) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- Food & Drinks [ END ]

-- Consumables - Other [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Consumables - Other ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (0) AND `subclass` IN (8) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- Consumables - Other [ END ]

-- Bags [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Bags ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (1) ORDER BY `itemlevel`;
-- Bags [ END ]

-- Axes - One-Handed [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Axes - One-Handed ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (0) AND `inventorytype` IN (13, 21, 22) ORDER BY `itemlevel`;
-- Axes - One-Handed [ END ]

-- Axes - Two-Handed [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Axes - Two-Handed ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (1) AND `inventorytype` IN (17) ORDER BY `itemlevel`;
-- Axes - One-Handed [ END ]

-- Bows [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Bows ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (2) AND `inventorytype` IN (15) ORDER BY `itemlevel`;
-- Bows [ END ]

-- Guns [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Guns ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (3) AND `inventorytype` IN (26) ORDER BY `itemlevel`;
-- Guns [ END ]

-- Maces - One-Handed [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Maces - One-Handed ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (4) AND `inventorytype` IN (13, 21, 22) ORDER BY `itemlevel`;
-- Maces - One-Handed [ END ]

-- Maces - Two-Handed [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Maces - Two-Handed ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (5) AND `inventorytype` IN (17) ORDER BY `itemlevel`;
-- Maces - Two-Handed [ END ]

-- Polearms [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Polearms ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (6) AND `inventorytype` IN (17) ORDER BY `itemlevel`;
-- Polearms [ END ]

-- Swords - One-Handed [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Swords - One-Handed ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (7) AND `inventorytype` IN (13, 21, 22) ORDER BY `itemlevel`;
-- Swords - One-Handed [ END ]

-- Swords - Two-Handed [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Swords - Two-Handed ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (8) AND `inventorytype` IN (17) ORDER BY `itemlevel`;
-- Swords - Two-Handed [ END ]

-- Staves [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Staves ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (10) AND `inventorytype` IN (17) ORDER BY `itemlevel`;
-- Staves [ END ]

-- Fist Weapons [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Fist Weapons ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (13) AND `inventorytype` IN (13, 22) ORDER BY `itemlevel`;
-- Fist Weapons [ END ]

-- Miscellaneous Weapons [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Miscellaneous Weapons ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (14) AND `inventorytype` IN (13, 17, 21) ORDER BY `itemlevel`;
-- Miscellaneous Weapons [ END ]

-- Daggers [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Daggers ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (15) AND `inventorytype` IN (13, 21, 22) ORDER BY `itemlevel`;
-- Daggers [ END ]

-- Throwing Weapons [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Throwing Weapons ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (16) AND `inventorytype` IN (25) ORDER BY `itemlevel`;
-- Throwing Weapons [ END ]

-- Crossbows [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Crossbows ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (18) AND `inventorytype` IN (26) ORDER BY `itemlevel`;
-- Crossbows [ END ]

-- Wands [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Wands ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (19) AND `inventorytype` IN (26) ORDER BY `itemlevel`;
-- Wands [ END ]

-- Fishing Poles [1-1] [ BEGIN ]
SET @VENDOR_COUNT := 1;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Fishing Poles ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (2) AND `subclass` IN (20) AND `inventorytype` IN (17) ORDER BY `itemlevel`;
-- Fishing Poles [ END ]

-- Gems [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Gems ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (3) ORDER BY `itemlevel`;
-- Gems [ END ]

-- Miscellaneous Armor [1-1] [ BEGIN ]
SET @VENDOR_COUNT := 1;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Miscellaneous Armor ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0) AND `inventorytype` IN (1, 3, 5, 6, 7, 8, 9, 10) ORDER BY `itemlevel`;
-- Miscellaneous Armor [ END ]

-- Necklaces [1-15] [ BEGIN ]
SET @VENDOR_COUNT := 15;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Necklaces ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0) AND `inventorytype` IN (2) ORDER BY `itemlevel`;
-- Necklaces [ END ]

-- Shirts [1-1] [ BEGIN ]
SET @VENDOR_COUNT := 1;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Shirts ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0) AND `inventorytype` IN (4) ORDER BY `itemlevel`;
-- Shirts [ END ]

-- Rings [1-20] [ BEGIN ]
SET @VENDOR_COUNT := 20;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Rings ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0) AND `inventorytype` IN (11) ORDER BY `itemlevel`;
-- Rings [ END ]

-- Trinkets [1-15] [ BEGIN ]
SET @VENDOR_COUNT := 15;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Trinkets ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0) AND `inventorytype` IN (12) ORDER BY `itemlevel`;
-- Trinkets [ END ]

-- Cloaks [1-15] [ BEGIN ]
SET @VENDOR_COUNT := 15;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloaks ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0, 1) AND `inventorytype` IN (16) ORDER BY `itemlevel`;
-- Cloaks [ END ]

-- Tabards [1-1] [ BEGIN ]
SET @VENDOR_COUNT := 1;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Tabards ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0) AND `inventorytype` IN (19) ORDER BY `itemlevel`;
-- Tabards [ END ]

-- Robes [1-15] [ BEGIN ]
SET @VENDOR_COUNT := 15;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Robes ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (0,1,2,3,4) AND `inventorytype` IN (20) ORDER BY `itemlevel`;
-- Robes [ END ]

-- Holdables [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Holdables ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4, 15) AND `subclass` IN (0) AND `inventorytype` IN (23) ORDER BY `itemlevel`;
-- Holdables [ END ]

-- [ CLOTH ARMOR SECTION ] 

-- Cloth - Head [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Head ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (1) ORDER BY `itemlevel`;
-- Cloth - Head [ END ]

-- Cloth - Shoulder [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Shoulder ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (3) ORDER BY `itemlevel`;
-- Cloth - Shoulder [ END ]

-- Cloth - Chest [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Chest ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (5) ORDER BY `itemlevel`;
-- Cloth - Chest [ END ]

-- Cloth - Waist [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Waist ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (6) ORDER BY `itemlevel`;
-- Cloth - Waist [ END ]

-- Cloth - Legs [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Legs ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (7) ORDER BY `itemlevel`;
-- Cloth - Legs [ END ]

-- Cloth - Feet [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Feet ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (8) ORDER BY `itemlevel`;
-- Cloth - Feet [ END ]

-- Cloth - Wrists [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Wrists ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (9) ORDER BY `itemlevel`;
-- Cloth - Wrists [ END ]

-- Cloth - Hands [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Cloth - Hands ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (1) AND `inventorytype` IN (10) ORDER BY `itemlevel`;
-- Cloth - Hands [ END ]

-- [ LEATHER ARMOR SECTION ] 

-- Leather - Head [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Head ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (1) ORDER BY `itemlevel`;
-- Leather - Head [ END ]

-- Leather - Shoulder [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Shoulder ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (3) ORDER BY `itemlevel`;
-- Leather - Shoulder [ END ]

-- Leather - Chest [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Chest ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (5) ORDER BY `itemlevel`;
-- Leather - Chest [ END ]

-- Leather - Waist [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Waist ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (6) ORDER BY `itemlevel`;
-- Leather - Waist [ END ]

-- Leather - Legs [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Legs ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (7) ORDER BY `itemlevel`;
-- Leather - Legs [ END ]

-- Leather - Feet [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Feet ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (8) ORDER BY `itemlevel`;
-- Leather - Feet [ END ]

-- Leather - Wrists [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Wrists ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (9) ORDER BY `itemlevel`;
-- Leather - Wrists [ END ]

-- Leather - Hands [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Leather - Hands ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (2) AND `inventorytype` IN (10) ORDER BY `itemlevel`;
-- Leather - Hands [ END ]

-- [ MAIL ARMOR SECTION ] 

-- Mail - Head [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Head ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (1) ORDER BY `itemlevel`;
-- Mail - Head [ END ]

-- Mail - Shoulder [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Shoulder ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (3) ORDER BY `itemlevel`;
-- Mail - Shoulder [ END ]

-- Mail - Chest [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Chest ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (5) ORDER BY `itemlevel`;
-- Mail - Chest [ END ]

-- Mail - Waist [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Waist ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (6) ORDER BY `itemlevel`;
-- Mail - Waist [ END ]

-- Mail - Legs [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Legs ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (7) ORDER BY `itemlevel`;
-- Mail - Legs [ END ]

-- Mail - Feet [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Feet ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (8) ORDER BY `itemlevel`;
-- Mail - Feet [ END ]

-- Mail - Wrists [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Wrists ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (9) ORDER BY `itemlevel`;
-- Mail - Wrists [ END ]

-- Mail - Hands [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mail - Hands ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (3) AND `inventorytype` IN (10) ORDER BY `itemlevel`;
-- Mail - Hands [ END ]

-- [ PLATE ARMOR SECTION ]

-- Plate - Head [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Head ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (1) ORDER BY `itemlevel`;
-- Plate - Head [ END ]

-- Plate - Shoulder [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Shoulder ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (3) ORDER BY `itemlevel`;
-- Plate - Shoulder [ END ]

-- Plate - Chest [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Chest ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (5) ORDER BY `itemlevel`;
-- Plate - Chest [ END ]

-- Plate - Waist [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Waist ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (6) ORDER BY `itemlevel`;
-- Plate - Waist [ END ]

-- Plate - Legs [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Legs ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (7) ORDER BY `itemlevel`;
-- Plate - Legs [ END ]

-- Plate - Feet [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Feet ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (8) ORDER BY `itemlevel`;
-- Plate - Feet [ END ]

-- Plate - Wrists [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Wrists ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (9) ORDER BY `itemlevel`;
-- Plate - Wrists [ END ]

-- Plate - Hands [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Plate - Hands ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (4) AND `inventorytype` IN (10) ORDER BY `itemlevel`;
-- Plate - Hands [ END ] 

-- [OTHER SECTION]

-- Shields [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Shields ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (6) AND `inventorytype` IN (14) ORDER BY `itemlevel`;
-- Shields [ END ] 

-- Relics [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Relics ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (4) AND `subclass` IN (11) AND `inventorytype` IN (28) ORDER BY `itemlevel`;
-- Relics [ END ] 

-- Trade Goods [1-10] [ BEGIN ]
SET @VENDOR_COUNT := 10;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Trade Goods ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (7) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- Trade Goods [ END ] 

-- Junk / Other [1-25] [ BEGIN ]
SET @VENDOR_COUNT := 25;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Junk / Other ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (15) AND `subclass` IN (0, 3, 4) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- Junk / Other [ END ] 

-- Mounts [1-5] [ BEGIN ]
SET @VENDOR_COUNT := 5;
SET @ENTRY_GEN_TAIL := @ENTRY_GEN_HEAD;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `faction_A`, `faction_H`, `npcflag`, `WDBVerified`)
SELECT @ENTRY_GEN_HEAD := @ENTRY_GEN_HEAD + 1, @M1, @M2, @M3, @M4, CONCAT('Mounts ', `number`), '', @FACTION, @FACTION, @NPC_FLAG, @WDBVERIFIED
FROM `temp_mall_data` WHERE `number` <= @VENDOR_COUNT;

SET @I_COUNT:= 0;
INSERT INTO npc_vendor (`entry`, `slot`, `item`)  
SELECT IF(@I_COUNT % 149 = 0, @ENTRY_GEN_TAIL := @ENTRY_GEN_TAIL + 1, @ENTRY_GEN_TAIL), @I_COUNT := @I_COUNT+1, `entry` 
FROM item_template WHERE `class` IN (15) AND `subclass` IN (5) AND `inventorytype` IN (0) ORDER BY `itemlevel`;
-- Junk / Other [ END ] 

COMMIT;
DROP TABLE `temp_mall_data`;

-- Display modified data

SELECT * FROM creature_template
WHERE `entry` BETWEEN @ENTRY_OFFSET_START AND @ENTRY_OFFSET_END
ORDER BY entry ASC;

SELECT `entry`, COUNT(*) `item count` FROM npc_vendor
WHERE `entry` BETWEEN @ENTRY_OFFSET_START AND @ENTRY_OFFSET_END
GROUP BY entry
ORDER BY entry, slot ASC;

SELECT * FROM npc_vendor
WHERE `entry` BETWEEN @ENTRY_OFFSET_START AND @ENTRY_OFFSET_END
ORDER BY entry, slot ASC;