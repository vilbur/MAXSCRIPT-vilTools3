filein( getFilenamePath(getSourceFileName()) + "/../rollout-SELECTION - EDIT POLY/Lib/vertexGridSelector/vertexGridSelector.ms" )	--"./../rollout-SELECTION - EDIT POLY/Lib/vertexGridSelector/vertexGridSelector.ms"

/**  Export format
  *
 */
macroscript	_print_select_lowest_verts
category:	"_Print-Points-Tools"
buttonText:	"Get Lowest Points"
toolTip:	"Get only signlge vertex of each face island"
icon:	"MENU:false|across:3|height:24"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")
	on execute do
	if selection.count > 0 then

	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-POINTS TOOLS.mcr"



		obj	= selection[1]

		VertexGridSelector 	= VertexGridSelector_v( obj ) resolution:15
		VertexGridSelector.getLowestVerts()
		VertexGridSelector.selectVerts()

	)
	--DosCommand ("explorer \""+export_dir+"\"")
	--format "EventFired	= % \n" EventFired
)


/**
  *
  */
macroscript	_print_select_ingle_vert_of_faces
category:	"_Print-Points-Tools"
buttonText:	"1 vert face"
toolTip:	"Get only signlge vertex of each face island"
icon:	"MENU:false|across:3|height:24"
(

	on execute do
	if subObjectLevel == 1 then
	undo "Filter 1 vert per face" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-POINTS TOOLS.mcr"

		VertexGridSelector 	= VertexGridSelector_v( selection[1] )

		VertexGridSelector.getSingleVertPerFaceIsland()
		VertexGridSelector.selectVerts()

	)
)
