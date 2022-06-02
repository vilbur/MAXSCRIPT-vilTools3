filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauu_connecttolastselvert.mcr" )

/**  
 *	
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Faces"  
buttonText:	"Connect"
toolTip:	"Connect To Last vertex"
--icon:	"#(path, index)"
(
	macros.run "miauu" "miauu_ConnectToLastSelVertAlt"
)