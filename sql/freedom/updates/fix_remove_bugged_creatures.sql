-- delete all specific, bugged creature entries
DELETE FROM world.creature_template
WHERE entry IN (0);

-- delete spawned game objects, not existing in the template anymore
DELETE FROM a
USING world.creature AS a
WHERE NOT EXISTS (SELECT 1 FROM world.creature_template b WHERE a.id = b.entry);