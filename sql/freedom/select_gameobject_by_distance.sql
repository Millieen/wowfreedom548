-- Finds gameobjects within @DISTANCE relative to @POS_X and @POS_Y coordinates
-- Fill in variables
SET @POS_X := 0;
SET @POS_Y := 0;
SET @MAP_ID := 0;
SET @DISTANCE := 0;

SELECT * FROM world.gameobject a WHERE 
a.map = @MAP_ID AND
(SQRT(POW(@POS_X - a.position_x, 2) + POW(@POS_Y - a.position_y, 2))) <= @DISTANCE;