
/**  
 *	
 */
macroscript	utilities_measure_and_select
category:	"_Utilities"
buttonText:	"Measure & Select"
tooltip:	"Select edges by its length or measure distance between verts, edges or objects"
icon:	"columns:8"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauumeasureandselect_v11_0.ms" )
	
	macros.run "miauu" "miauuMeasureAndSelect"
)


/**  
 *	
 */
macroscript	utilities_camera_match
category:	"_Utilities"
buttonText:	"Camera Match"
icon:	"columns:8"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/111_cameraMatch_v0.4.ms" )
)