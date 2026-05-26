filein( getFilenamePath(getSourceFileName()) + "/ImportAllDwgsFromDirectory/ImportAllDwgsFromDirectory.ms" )	--"./ImportAllDwgsFromDirectory/ImportAllDwgsFromDirectory.ms"


/**
  
	If current scene folder contains DWG files → use it automatically.

	Otherwise asks for folder.

	Checks units and optionally switches scene to millimeters.

	Imports each DWG into current scene.

	Creates parent layer named after DWG filename.

	Moves all newly created imported layers under that parent layer.

	Moves imported objects into that parent layer as well.

 */
macroscript	_scene_import_dwg_mass
category:	"_Scene-Save"
buttontext:	"Mass import DWG"
toolTip:	"Mass import DWG.\n\nCurrent max file dir is used if contains any DWG files.\n\nCTRL: RESET IMPORT SCALE"
icon:	"ACROSS:4"
(
	on isVisible return objects.count > 0

	on execute do
	(
		reset_scale_settings = keyboard.controlPressed
		
		massDWGImporter = massDWGImporter_v()
		
		--massDWGImporter.ImportAllDwgs()
		 massDWGImporter.ImportAllDwgs reset_scale_settings:reset_scale_settings
	)
)
