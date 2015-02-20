-- Description: Removes duplicate (same object in same place) entries from export gameobject table.

-- requires index at least on `id` column on world.gameobject
-- else it gets stuck/too slow of a query
-- therefore, temp index created and dropped after delete action
START TRANSACTION;
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
COMMIT;