clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TechArch.ms" )	-- "./../TechArch.ms"



delete objects

/*------------------------------------------------------------------------------
	RUN TESST
--------------------------------------------------------------------------------*/
--TechArch wirecolor:green isSelected:on

/* RADIUS TEST */
--TechArch radius_min:50 radius_max:100 radius_mode:2 isSelected:on steps:24


/* EVENT\ODD ANGLE */
TechArch angle_min:30 angle_max:90 isSelected:on radius_min:50 radius_max:51

/* RANDOM ANGLE */
--TechArch angle_min:15 angle_max:30 angle_mode:2 isSelected:on radius_min:50 radius_max:51

--TechArch wrap_angle:72 radius_min:45 radius_max:90 angle_min:angle_min height:height gap_angle:gap_angle radius_mode:radius_mode angle_mode:angle_mode isSelected:on steps:24
--lineSetup()

max modify mode

/*------------------------------------------------------------------------------
	ADD MODIFIERS
--------------------------------------------------------------------------------*/

/* ADD SPLINE OFFSET */
--spline_offset = SplineOffset ()
--
--
--spline_offset.algorithm = 1 -- set 3D model
--
--spline_offset.numberparallels = 4
--spline_offset.offset = 1

--addModifier objects[1] spline_offset

--max modify mode