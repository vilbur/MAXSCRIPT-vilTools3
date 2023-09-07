
/** KILL CALLBACKS ON START
 *
 */

--setModelingMaterialKill() -- kill for case of restart of UI

/**
 */
macroscript	material_editor_open
category:	"_Material-Edit"
buttonText:	"Mat Editor"
tooltip:	"Open Material Editor"
icon:	"MENU:true"
(
	actionMan.executeAction 0 "50048"  -- Tools: Material Editor Toggle
)


/**
 */
macroscript	material_id_by_object
category:	"_Material-Edit"
buttonText:	"Mat ID By Object"
tooltip:	"Set different material ID for each object"
icon:	"MENU:true"
(
	--EditPoly = Epoly_v()
	_selection = for o in geometry collect o


	for i=1 to _selection.count do
	(
		select _selection[i]
		(Epoly_v()).setMatIdToObject i
	)

	select _selection

	CompleteRedraw()
)


/**  Create multimaterial where each material ID has different color
 */
macroscript	material_remove
category:	"_Material-Edit"
buttonText:	"Remove"
tooltip:	"Remove material from selection"
icon:	"MENU:true"
(

	selection.material = undefined
)

-- instantiate the object

/**
 */
macroscript	material_assign_id
category:	"_Material-ID"
buttonText:	"Set Mat ID"
tooltip:	"Set Mat ID"
icon:	"MENU:true"
(
	--actionMan.executeAction 0 "50048"  -- Tools: Material Editor Toggle
	filein( getFilenamePath(getSourceFileName()) + "/Lib/MaterialIdAssigner/MaterialIdAssigner.ms" )	-- "./Lib/MaterialIdAssigner/MaterialIdAssigner.ms"

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MATERIALS\Lib\MaterialIdAssigner\MaterialIdAssigner.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MATERIALS\Edit.mcr"

	--default_text	= "2"
	--_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" default_text
	--_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"
	--
	--_dotNet.ShowModal()
	--
	--_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
	--_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )
	--
	--format "( id = _dotNet.InstanceName) as integer:	% \n" (( id = _dotNet.InstanceName) as integer)
	--
	--if( _ok and  ( id = _dotNet.InstanceName  as integer ) != undefined ) then
	--(
	--	format "id:	% \n" id
	--
	--	MaterialIdAssigner = MaterialIdAssigner_v()
	--
	--	MaterialIdAssigner.setMatId( id )

	--)
--
		MaterialIdAssigner = MaterialIdAssigner_v()

		MaterialIdAssigner.setMatId( 5 )

)
