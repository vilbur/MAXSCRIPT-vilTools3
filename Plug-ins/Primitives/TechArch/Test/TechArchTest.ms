clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TechArch.ms" )	-- "./../TechArch.ms"


positions = #()

/** Get pos
  *
  */
function getPos =
(
	pos = [ positions.count *150, 0, 0 ]

	append positions pos

	pos --return
)

delete objects


/*------------------------------------------------------------------------------
	RUN TESST
--------------------------------------------------------------------------------*/

/* WELD AND CONNECT LINE  */
TechArch height:10  name:"Connect and Weld" pos:(getPos())

/* NOT WELD LINE  */
TechArch  weld_line:false height:10 name:"Connect" pos:(getPos())

/* NOT CONNECT LINE  */
TechArch connect_line:false name:"Not Connect" pos:(getPos())


/* NOT WELD  AND ORTHO  */
TechArch  weld_line:false connect_mode:2  height:10 name:"Connect Ortho" pos:(getPos())


/* WELD AND ORTHO  */
TechArch height:10 connect_mode:3 name:"Weld Ortho Flip" pos:(getPos())


/* RADIUS TEST */
--TechArch radius_min:50 radius_max:100 radius_mode:1 isSelected:on steps:64
--TechArch radius_min:50 radius_max:100 radius_mode:2 isSelected:on steps:24
--


/* EVENT\ODD ANGLE */
--TechArch angle_min:30 angle_max:90 isSelected:on radius_min:50 radius_max:55

/* RANDOM ANGLE */
--TechArch angle_min:15 angle_max:30 angle_mode:2 isSelected:on radius_min:50 radius_max:51

--TechArch angle_min:45 angle_max:90 isSelected:on radius_min:50 radius_max:51


/* EVENT\ODD HEIGHT */
--TechArch height:30
--
--/* RANDOM HEIGHT */
--TechArch height:50 height_mode:2



/* CLOSE LINE  */
--TechArch weld_line:false height:30 angle_min:180



/* TEST DIFFERENT SETUPS */
--TechArch angle_min:30 angle_max:60 radius_min:50 radius_max:60 radius_mode:3 angle_mode:2 height:10 isSelected:on



----TechArch wrap_angle:72 radius_min:45 radius_max:90 angle_min:angle_min height:height gap_angle:gap_angle radius_mode:radius_mode angle_mode:angle_mode isSelected:on steps:24
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