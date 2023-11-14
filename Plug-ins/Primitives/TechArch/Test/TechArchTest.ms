clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TechArch.ms" )	-- "./../TechArch.ms"



delete objects

/* DEFAULT VALUES */
--tech_arch = techArch()

/* MAIN CONFIG */
radius	= 100
wrap_angle	= 720
angle_min	= 30
width	= 50
height	= 30
chamfer_val	= 0


--tech_arch = techArch radius:radius wrap_angle:wrap_angle angle_min:angle_min width:width height:height chamfer:chamfer_val


/* CONFIG LINE VALUES */
attach_to_line	= true
attach_to_line	= false

weld_line	= true
weld_line	= false

connect_line	= true
connect_line	= false

close_line	= true
close_line	= false

tech_arch = techArch attach_to_line:attach_to_line weld_line:weld_line connect_line:connect_line close_line:close_line



/* ADD SPLINE OFFSET */
spline_offset = SplineOffset ()


spline_offset.algorithm = 1 -- set 3D model

spline_offset.numberparallels = 4
spline_offset.offset = 1

--addModifier tech_arch spline_offset

modPanel.setCurrentObject tech_arch.baseObject

max modify mode