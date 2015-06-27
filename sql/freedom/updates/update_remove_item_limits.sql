-- WARNING: IRREVERSIBLE UPDATE, MAKE SURE TO BACKUP ITEM_TEMPLATE
USE `world`;
START TRANSACTION;
UPDATE item_template a SET 
	a.BuyPrice = 0, -- items do not cost anything
	a.SellPrice = 1, -- items can be sold for 1 copper (if 0, then can't quick-sell them to quickly get rid of the items)
	a.AllowableClass = ~0 >> 33, -- all classes can use any items
	a.AllowableRace = ~0 >> 33, -- all races can use any items
	a.RequiredSkill = 0,
	a.RequiredSkillRank = 0,
	a.requiredspell = 0,
	a.requiredhonorrank = 0,
	a.RequiredCityRank = 0,
	a.RequiredReputationFaction = 0,
	a.RequiredReputationRank = 0,
	a.FlagsExtra = a.FlagsExtra & (~3); -- remove HORDE_ONLY & ALLIANCE_ONLY bit-wise flags
	
-- make all items available in mall vendors public for .additem command
SET @ENTRY_OFFSET_START := 90000;
SET @ENTRY_OFFSET_END   := 99999;

CREATE INDEX `temp` ON world.npc_vendor(`item`);

UPDATE item_template a
SET a.public = 1
WHERE EXISTS (SELECT 1 FROM npc_vendor b WHERE b.item = a.entry AND b.entry BETWEEN @ENTRY_OFFSET_START AND @ENTRY_OFFSET_END);

DROP INDEX `temp` ON world.npc_vendor;

COMMIT;