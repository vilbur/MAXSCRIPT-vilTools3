--filein( getFilenamePath(getSourceFileName()) + "/setSymmetryModifier.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/setSymmetryModifier.ms" )

/*------------------------------------------------------------------------------
	SYMMETRY
--------------------------------------------------------------------------------*/




/**  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5084C26B-B37D-415C-9ADC-DC7440DEE9BC
  */
macroscript	modifier_symmetry_mod_x
category:	"_Modifiers"
buttonText:	"Symmetry X"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
icon:	"across:3"
(
	--filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-MODIFIERS\Symmetry.mcr" ) -- DEV

	for obj in selection do
		setSymmetryModifier obj axis:#X object_space: keyboard.controlPressed
)

/**
  */
macroscript	modifier_symmetry_mod_y
category:	"_Modifiers"
buttonText:	"Symmetry Y"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
(
	--filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-MODIFIERS\Symmetry.mcr" ) -- DEV

	for obj in selection do
		setSymmetryModifier obj axis:#Y object_space: keyboard.controlPressed
)

/**
  */
macroscript	modifier_symmetry_mod_z
category:	"_Modifiers"
buttonText:	"Symmetry Z"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
(
	--filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-MODIFIERS\Symmetry.mcr" ) -- DEV

	for obj in selection do
		setSymmetryModifier obj axis:#Z object_space: keyboard.controlPressed
)
