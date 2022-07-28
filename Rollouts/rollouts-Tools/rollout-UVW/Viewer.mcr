--filein( getFilenamePath(getSourceFileName()) + "/Lib/UvwViewer.ms" )

/**  LINK TO NODE
 */
macroscript	_UVW_Viewer
category:	"_UVW"
buttontext:	"UVW Viewer"
toolTip:	"UVW viewer"
--icon:	"Across:1"

--icon:	"Groupbox:Nodes"
--icon:	"type:checkbutton"
(
	--clearListener() -- DEV
	--filein( getFilenamePath(getSourceFileName()) + "/Lib/UvwViewer.ms" ) -- DEV
	
	--UvwViewer 	= UvwViewer_v()
	
	--UvwViewer.drawUVW()
)

