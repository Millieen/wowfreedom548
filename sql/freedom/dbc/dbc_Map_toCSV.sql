 -- using WoWParser2_Build98 to convert this exported CSV to DBC
SELECT 'int','string','int','int','int','string','int','string','string','int','float','int','float','float','int','int','int','int','int'
UNION ALL
SELECT 
	`id`, 
	CONCAT('"', REPLACE(`directory`, '\\n', '\\N'), '"'), -- REPLACE \n => \N function due to WoWParser2_Build98 bug
	`type`,
	`Flags`,
	`PVP`,
	CONCAT('"', REPLACE(`MapName`, '\\n', '\\N'), '"'),
	`areaTableID`,
	IF(CONCAT('"', `MapDescription0`, '"') = '""', '', CONCAT('"', `MapDescription0`, '"')),
	IF(CONCAT('"', `MapDescription1`, '"') = '""', '', CONCAT('"', `MapDescription1`, '"')),
	`LoadingScreenID`,
	`minimapIconScale`,
	`corpseMapID`,
	`corpseX`,
	`corpseY`,
	`timeOfDayOverride`,
	`expansionID`,
	`raidOffset`,
	`maxPlayers`,
	`rootPhaseMap`
INTO OUTFILE 'D:\\WoW Freedom Development\\TOOLS\\wowfreedom548tools\\WoWParser2_Build98\\workspace\\Map.csv' -- replace wherever you want CSV extracted to
FIELDS TERMINATED BY ','
ESCAPED BY '' 
FROM dbc_map;