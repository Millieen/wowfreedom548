SET @MAP := 607; SET @ZONE := 4384; SET @POS_X := 836.952; SET @POS_Y = -108.702; SET @POS_Z = 111.747; SET @POS_O = 0.089445;
START TRANSACTION;
UPDATE world.playercreateinfo SET
	map = @MAP,
	zone = @ZONE,
	position_x = @POS_X,
	position_y = @POS_Y,
	position_z = @POS_Z,
	orientation = @POS_O;							  
COMMIT;