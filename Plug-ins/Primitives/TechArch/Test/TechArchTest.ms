clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TechArch.ms" )	-- "./../TechArch.ms"



/** Default setup
  *
  */
function defaultSetup =
(
	--format "\n"; print "TechArchTest.ms.defaultSetup()"
	--tech_arch = techArch()
	tech_arch = techArch wirecolor:green isSelected:on
	--tech_arch = techArch pos:[ 30, 30, 0]

	--format "tech_arch.pos:	% \n" tech_arch.pos
)


/** Main setup
  *
  */
function mainSetup =
(
	--format "\n"; print "TechArchTest.ms.mainSetup()"
	radius	= 60

	wrap_angle	= 720
	--wrap_angle	= 180
	--wrap_angle	= 360
	--wrap_angle	= 540

	angle_min	= 90
	angle_max	= 60

	width	= 15
	height	= 30
	gap_angle	= 0
	radius_mode	= 2
	angle_mode	= 2

	tech_arch = techArch radius:radius wrap_angle:wrap_angle angle_min:angle_min width:width height:height gap_angle:gap_angle radius_mode:radius_mode angle_mode:angle_mode isSelected:on
)


/* CONFIG LINE VALUES */

/** Line setup
  *
  */
function lineSetup =
(
	--format "\n"; print "TechArchTest.ms.lineSetup()"
	attach_to_line	= true
	--attach_to_line	= false

	weld_line	= true
	--weld_line	= false

	connect_line	= true
	--connect_line	= false

	close_line	= true
	--close_line	= false

	tech_arch = techArch attach_to_line:attach_to_line weld_line:weld_line connect_line:connect_line close_line:close_line height:10

)



delete objects

/*------------------------------------------------------------------------------
	RUN TESST
--------------------------------------------------------------------------------*/
--defaultSetup()

mainSetup()

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