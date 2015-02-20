-- ct434 gameobject must be inserted into test.gameobject table first, then refined for insertion
-- if not refined, then there is potential for duplicate objects (same objects in exact same place)
-- if refined for insertion, execute this
START TRANSACTION;
INSERT INTO world.gameobject (
	`id`,
	`map`,
	`spawnMask`,
	`phaseMask`,
	`position_x`,
	`position_y`,
	`position_z`,
	`orientation`,
	`rotation0`,
	`rotation1`,
	`rotation2`,
	`rotation3`,
	`spawntimesecs`,
	`animprogress`,
	`state`,
	`size`,
	`owner`,
	`created`
)
SELECT
	`id`,
	`map`,
	`spawnMask`,
	`phaseMask`,
	`position_x`,
	`position_y`,
	`position_z`,
	`orientation`,
	`rotation0`,
	`rotation1`,
	`rotation2`,
	`rotation3`,
	`spawntimesecs`,
	`animprogress`,
	`state`,
	`size`,
	`owner`,
	`creation_date`
FROM
	test.gameobject;
COMMIT;