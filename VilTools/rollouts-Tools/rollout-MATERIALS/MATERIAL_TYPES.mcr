filein( getFilenamePath(getSourceFileName()) + "/Lib/MaterialId/MaterialId.ms" ) -- "./Lib/MaterialId/MaterialId.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callback/setModelingMaterial.ms" )


/** KILL CALLBACKS ON START
 *
 */

--setModelingMaterialKill() -- kill for case of restart of UI



/**  Create multimaterial where each material ID has different color
 */
macroscript	material_assign_idmat
category:	"_Material-Types"
buttonText:	"Multi ID"
tooltip:	"Create multimaterial where each material ID has different color"
icon:	"MENU:true"
(
	_Material = MaterialId_v()

	selection.material = _Material.createtMultiIdMaterial()
)


/*------------------------------------------------------------------------------
	MODELING GREY MATERIAL
--------------------------------------------------------------------------------*/
/**  Create multimaterial where each material ID has different color
 */
macroscript	material_assign_standard_grey
category:	"_Material-Types"
buttonText:	"Standard Grey"
tooltip:	"TURN ON"
icon:	"MENU:true"
(
	mat = (Material_v()).StandartMat.create "Grey" diffuse:( color 200 200 200 )

	selection.material = mat
)


/*------------------------------------------------------------------------------
	X RAY MATERIAL
--------------------------------------------------------------------------------*/

/**  Create multimaterial where each material ID has different color
 */
macroscript	material_assign_xray_mat
category:	"_Material-Types"
buttonText:	"X-Ray"
tooltip:	"TURN ON"
icon:	"MENU:true|tooltip:Set transparency on objects material,\nor assign X-Ray material, if material is undefined."
(
	--clearListener(); print("Cleared in:"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MATERIALS\Lib\Material\Material.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MATERIALS\MATERIAL TYPES.mcr"


	_Material = Material_v()

	opacity = 10

	selection_materials = _Material.getMaterialsOfObjects( selection )

	--if ( mat_xray = _Material.getMat("X-Ray") ) == undefined then
		mat_xray = _Material.StandartMat.create "X-Ray" diffuse:( color 135 175 205 ) opacity:opacity

	--format "mat_xray:	% \n" mat_xray

	format "classOf mat_xray:	% \n" (classOf mat_xray)

	for obj in selection where obj.mat == undefined do
		obj.material = mat_xray

	for mat in selection_materials where classOf mat == Standardmaterial do
		mat.opacity = opacity

	--format "selection_materials:	% \n" selection_materials
	--selection.material = _Material.createtMultiIdMaterial()
)

/**  Create multimaterial where each material ID has different color
 */
macroscript	material_remove_opacity_from_selected_materials
category:	"_Material-Types"
buttonText:	"X-Ray"
tooltip:	"TURN OFF"
icon:	"menu:true"
(

	selection_materials = (Material_v()).getMaterialsOfObjects( selection )

	for mat in selection_materials where classOf mat == Standardmaterial do
		mat.opacity = 100
)









/** SET TEMPORARY MODELING MATERIAL TO SELECTED OBECTS

		DO NOT DELETE
 */
--macroscript	material_assign_modeling
--category:	"_Material-Types"
--buttonText:	"Modeling"
--tooltip:	"Shade material for modeling"
--icon:	"control:checkbutton"
--(
--	global MODELING_MATERIAL_STORE = #( )
--
--	if( EventFired.value == true ) then
--	(
--		setSelectionLastKill()
--
--		setModelingMaterialCallback()
--
--		setSelectionLastCallback()
--	)
--	else
--	(
--		_selection = selection
--
--		deselect selection
--
--		setModelingMaterialKill()
--
--		select _selection
--	)
--)






