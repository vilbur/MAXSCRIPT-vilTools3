clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TechArch.ms" )	-- "./../TechArch.ms"



delete objects

tech_arch = techArch isSelected:on

spline_offset = SplineOffset ()


spline_offset.algorithm = 1 -- set 3D model

spline_offset.numberparallels = 4
spline_offset.offset = 1

--addModifier tech_arch spline_offset

modPanel.setCurrentObject tech_arch.baseObject

max modify mode