
/*------------------------------------------------------------------------------
	WORKING LAYER DIALOG
--------------------------------------------------------------------------------*/

/** WORKING LAYER DIALOG
 */
macroscript	layers_manager_toogle_dialog
category:	"_Layers-Dialogs"
buttontext:	"Working Layers"
tooltip:	"Open Working Layers Dialog.\n\nCreate for each layer of selected layer or selected object"
--icon:	"control:checkbutton|MENU:true|title:LAYER TOOGLE"
icon:	"MENU:Working Layers Dialog"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		 filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"

		LayersToogleDialog = LayersToogleDialog_v()

		LayersToogleDialog.create()
	)

	on altExecute type do
	(
		macros.run "_Layers-Dialogs" "layers_manager_toogle_dialog_resetini"
	)

)

/** WORKING LAYER DIALOG - RELAOD
 */
macroscript	layers_manager_toogle_dialog_resetini
category:	"_Layers-Dialogs"
buttontext:	"Working Layers"
tooltip:	"Reload with new layers set"
--icon:	"control:checkbutton"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"

		LayersToogleDialog = LayersToogleDialog_v()

		LayersToogleDialog.resetLayers()

		LayersToogleDialog.create()
	)
)

/** ADD LAYERS TO WORKING LAYER DIALOG
 */
macroscript	layers_manager_toogle_dialog_add_selected_layers
category:	"_Layers-Dialogs"
buttontext:	"Working Layers Add"
tooltip:	"Add selected layer to Working Layers Dialog"
--icon:	"control:checkbutton|MENU:true|title:LAYER TOOGLE"
icon:	"MENU:true"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		 filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"


		LayersToogleDialog = LayersToogleDialog_v()

		old_layers = LayersToogleDialog.getLayersFromIni()
		add_layers = LayersToogleDialog.getSelectedLayers()

		LayersToogleDialog.create layers:( makeUniqueArray ( join old_layers add_layers)  )
	)
)

/** REMOVE LAYERS TO WORKING LAYER DIALOG
 */
macroscript	layers_manager_toogle_dialog_remove_selected_layers
category:	"_Layers-Dialogs"
buttontext:	"Working Layers Remove"
tooltip:	"Remove selected layer to Working Layers Dialog"
icon:	"MENU:true"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		 filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"


		LayersToogleDialog = LayersToogleDialog_v()

		old_layers	= LayersToogleDialog.getLayersFromIni()
		remove_layers	= LayersToogleDialog.getSelectedLayers()


		format "\n-----------\nARRAY:old_layers:\n";  for layer in remove_layers do format "old_layers:	%\n" layer.name

		format "\n-----------\nARRAY:remove_layers:\n";  for layer in remove_layers do format "remove_layers:	%\n" layer.name

		LayersToogleDialog.create layers:( LayersToogleDialog.difference( old_layers )(remove_layers)  )

		--LayersToogleDialog.create layers:( old_layers  )
	)
)