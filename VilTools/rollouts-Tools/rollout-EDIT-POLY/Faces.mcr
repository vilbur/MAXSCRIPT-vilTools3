/**  
 *	
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Faces"  
buttontext:	"Merge Faces"
toolTip:	"Merge Faces"
--icon:	"#(path, index)"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/merge_faces_v10.ms" )

	macros.run "miauu" "Merge_Faces_v10"
)
