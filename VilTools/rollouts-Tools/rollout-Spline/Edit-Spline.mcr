filein( getFilenamePath(getSourceFileName()) + "/Lib/ConnectVertices.ms" )

/**  
 *	
 */
macroscript	_spline_connect_vertices
category:	"_Edit-Spline"
buttontext:	"Connect"
toolTip:	"Connect and weld"
--icon:	"#(path, index)"
(
	ConnectVertices_v()
)
