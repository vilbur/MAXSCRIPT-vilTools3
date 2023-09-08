
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

/*------------------------------------------------------------------------------
	SET MATERAL ID
--------------------------------------------------------------------------------*/
/**
 */
macroscript	material_assign_id_1
category:	"_Material-ID"
buttonText:	"Mat ID 1"
tooltip:	"Set Mat ID 1"
icon:	"MENU:true"
(

	on execute do
		for obj in selection do
			(MaterialIdAssigner_v()).setMatId( obj ) ( 1 )
)

/**
 */
macroscript	material_assign_id_2
category:	"_Material-ID"
buttonText:	"Mat ID 2"
tooltip:	"Set Mat ID 2"
icon:	"MENU:true"
(

	on execute do
		for obj in selection do
			(MaterialIdAssigner_v()).setMatId( obj ) ( 2 )
)


/**
 */
macroscript	material_assign_id_3
category:	"_Material-ID"
buttonText:	"Mat ID 3"
tooltip:	"Set Mat ID 3"
icon:	"MENU:true"
(

	on execute do
		for obj in selection do
			(MaterialIdAssigner_v()).setMatId( obj ) ( 3 )
)

/**
 */
macroscript	material_assign_id_4
category:	"_Material-ID"
buttonText:	"Mat ID 4"
tooltip:	"Set Mat ID 4"
icon:	"MENU:true"
(

	on execute do
		for obj in selection do
			(MaterialIdAssigner_v()).setMatId( obj ) ( 4 )
)

/**
 */
macroscript	material_assign_id_5
category:	"_Material-ID"
buttonText:	"Mat ID 5"
tooltip:	"Set Mat ID 5"
icon:	"MENU:true"
(

	on execute do
		for obj in selection do
			(MaterialIdAssigner_v()).setMatId( obj ) ( 5 )
)

/*------------------------------------------------------------------------------
	SET MATERAL ID DILAOG
--------------------------------------------------------------------------------*/
--/**
-- */
--macroscript	material_assign_id_dialog
--category:	"_Material-ID"
--buttonText:	"Set Mat ID"
--tooltip:	"Set Mat ID"
--icon:	"MENU:true"
--(
--	--actionMan.executeAction 0 "50048"  -- Tools: Material Editor Toggle
--	filein( getFilenamePath(getSourceFileName()) + "/Lib/MaterialIdAssigner/MaterialIdAssigner.ms" )	-- "./Lib/MaterialIdAssigner/MaterialIdAssigner.ms"
--
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MATERIALS\Lib\MaterialIdAssigner\MaterialIdAssigner.ms"
--	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MATERIALS\Edit.mcr"
--
--	default_text	= "2"
--	_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" default_text
--	_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"
--
--	_dotNet.ShowModal()
--
--	_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
--	_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )
--
--	format "( id = _dotNet.InstanceName) as integer:	% \n" (( id = _dotNet.InstanceName) as integer)
--
--	if( _ok and  ( id = _dotNet.InstanceName  as integer ) != undefined ) then
--	(
--		format "id:	% \n" id
--
--		for obj in selection do
--			(MaterialIdAssigner_v()).setMatId( obj ) ( id )
--
--	)
--
--)
--
