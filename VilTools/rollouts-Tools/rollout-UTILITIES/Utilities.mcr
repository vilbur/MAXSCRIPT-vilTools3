
/**
 *
 */
macroscript	utilities_measure_and_select
category:	"_Utilities"
buttonText:	"Measure & Select"
tooltip:	"Select edges by its length or measure distance between verts, edges or objects"
icon:	"columns:8"
(
	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauumeasureandselect_v11_0.ms" )

		macros.run "miauu" "miauuMeasureAndSelect"

	)
)


/**
 *
 */
macroscript	utilities_camera_match
category:	"_Utilities"
buttonText:	"Camera Match"
icon:	"columns:8"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/111_cameraMatch_v0.4.ms" )
)

/**
 *
 */
macroscript	utilities_rock_generator
category:	"_Utilities"
buttonText:	"Rock Generator"
icon:	"columns:8"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Rock-Generator1x0.ms" )	--"./../../../Lib/vendor/Rockgenerator1x0.mse"
)