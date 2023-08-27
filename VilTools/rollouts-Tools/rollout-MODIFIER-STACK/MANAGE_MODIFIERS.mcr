


/*------------------------------------------------------------------------------
	AUTO END RESULT
--------------------------------------------------------------------------------*/


macroscript	modifiers_select_instrances
category:	"_Modifiers-Manage"
buttontext:	"Select Instances"
toolTip:	"Select objects with instance of current modifier"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/Lib/InstancedModifierFinder/InstancedModifierFinder.ms" )	-- "./Lib/InstancedModifierFinder/InstancedModifierFinder.ms"
		objects_with_mod = (InstancedModifierFinder_v( objects )).getObjectsWithInstance ( modPanel.getCurrentObject() )


		if objects_with_mod.count > 0 then
			select objects_with_mod

		else
			messageBox "There is no objects with this modifier instance" title:"MODIFIER INSTANCE"

	)
)

/**
  *
  */
macroscript	modifiers_rename_current
category:	"_Modifiers-Manage"
buttontext:	"Rename"
toolTip:	"Rename current modifier"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

	on execute do
	(

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
		(
			format "classOf curr_mod:	% \n" (classOf curr_mod)
			default_mod = execute ( (classOf curr_mod) as string +"()")

			default_text = if default_mod.name == curr_mod.name then
				case classOf curr_mod of
				(
					Poly_Select:	"Select "
					Edit_Poly:	"Epoly "
					Vol__Select:	"SelectVol "
					default:	curr_mod.name
				)
			else
				curr_mod.name

			_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" default_text
			_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"

			_dotNet.ShowModal()

			_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
			_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )

			if( _ok and (_string = _dotNet.InstanceName) != ""  ) then
				curr_mod.name = _string

		)

	)
)