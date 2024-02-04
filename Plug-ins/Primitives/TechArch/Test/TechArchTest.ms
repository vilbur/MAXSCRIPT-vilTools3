clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TechArch.ms" )	-- "./../TechArch.ms" pos:[ pos_x+=x_add, 0, 0 ]


delete objects

pos_x = 0
x_add = 120
pos_x-= x_add

/*------------------------------------------------------------------------------
	RUN TESST
--------------------------------------------------------------------------------*/

/* DEFAULT */
TechArch name:"DEFAULT" pos:[ pos_x+=x_add, 0, 0 ]


/* CONNECT AND WELD LINE  */
--TechArch height:10  name:"CONNECT AND WELD" pos:[ pos_x+=x_add, 0, 0 ]
--
--/* NOT WELD LINE  */
--TechArch  weld_line:false height:10 name:"NOT WELD" pos:[ pos_x+=x_add, 0, 0 ]
--
--/* NOT CONNECT LINE  */
--TechArch connect_line:false name:" NOT CONNECT" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--/* NOT WELD  AND ORTHO  */
--TechArch  weld_line:false connect_mode:2  height:10 name:"NOT WELD  AND ORTHO" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--/* WELD AND ORTHO  */
--TechArch height:10 connect_mode:3 name:"WELD AND ORTHO" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--/* ANGLE GAP */
--TechArch angle_gap:10 radius_min:50 radius_max:55 name:"ANGLE GAP" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--/* RADIUS TEST */
--TechArch radius_min:50 radius_max:100 radius_mode:1 name:"RADIUS TEST A" steps:64 pos:[ pos_x+=x_add, 0, 0 ]
--TechArch radius_min:50 radius_max:100 radius_mode:2 name:"RADIUS TEST B" steps:24 pos:[ pos_x+=x_add, 0, 0 ]
--
--
--
--/* EVENT\ODD ANGLE */
--TechArch angle_min:30 angle_max:90 angle_mode:1 radius_min:50 radius_max:55 radius_mode:1 name:"Event\Odd Angle"  pos:[ pos_x+=x_add, 0, 0 ]
--
--/* RANDOM ANGLE */
--TechArch angle_min:15 angle_max:45 angle_mode:2 radius_min:50 radius_max:55  name:"RANDOM ANGLE A" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--TechArch angle_min:45 angle_max:90 isSelected:on radius_min:50 radius_max:51 name:"RANDOM ANGLE B" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--/* EVENT\ODD HEIGHT */
--TechArch height:30 name:"EVENT\ODD HEIGHT" pos:[ pos_x+=x_add, 0, 0 ]
--
--/* RANDOM HEIGHT */
--TechArch height:50 height_mode:2 name:"RANDOM HEIGHT" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--
--/* CLOSE LINE  */
--TechArch weld_line:false height:30 angle_min:180 name:"CLOSE LINE" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--
--/* TEST DIFFERENT CONFIGURATIONS */
--TechArch angle_min:30 angle_max:60 radius_min:50 radius_max:60 radius_mode:3 angle_mode:2 height:10 name:"CUSTOM 1" pos:[ pos_x+=x_add, 0, 0 ]
--
--
--
------TechArch wrap_angle:72 radius_min:45 radius_max:90 angle_min:angle_min height:height gap_angle:gap_angle radius_mode:radius_mode angle_mode:angle_mode isSelected:on steps:24 pos:[ pos_x+=x_add, 0, 0 ]
----lineSetup()
--


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