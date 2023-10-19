filein( getFilenamePath(getSourceFileName()) + "/Lib/MirrorByGizmo/MirrorByGizmo.ms" )	-- "./Lib/MirrorByGizmo/MirrorByGizmo.ms"


/**
  */
macroscript	selection_mirror_instance
category:	"_Mirror"
buttontext:	"Instance By Wolrd"
toolTip:	"Mirror instances by world axis.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP"
icon:	"MENU:Mirror Instance By Wolrd"
(
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\MIRROR.mcr"

		undo "Mirror X" on
			mirrorSelection(#WORLD)(#INSTANCE)
	)
)

/**
  */
macroscript	selection_mirror_copy
category:	"_Mirror"
buttontext:	"Copy By Wolrd"
toolTip:	"Mirror Copy by pivot axis.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP"
icon:	"MENU:Mirror Copy By Wolrd"
(
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\MIRROR.mcr"

		undo "Mirror X" on
			mirrorSelection(#WORLD)(#COPY)
	)
)

--/*------------------------------------------------------------------------------
--	MIRROR BY PIVOT
----------------------------------------------------------------------------------*/
--/**
--  */
--macroscript	selection_mirror_instance_pivot
--category:	"_Mirror"
--buttontext:	"Mirror Instance By Pivot"
--toolTip:	"Mirror instances in world axis.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP"
--icon:	"MENU:true"
--(
--	on execute do
--	(
--		clearListener(); print("Cleared in:\n"+getSourceFileName())
--		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"
--
--		undo "Mirror X" on
--			mirrorSelection(#PIVOT)(#INSTANCE)
--	)
--)
--
--/**
--  */
--macroscript	selection_mirror_copy_pivot
--category:	"_Mirror"
--buttontext:	"Mirror Instance By Pivot"
--toolTip:	"Mirror instances in world axis.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP"
--icon:	"MENU:true"
--(
--	on execute do
--	(
--		clearListener(); print("Cleared in:\n"+getSourceFileName())
--		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"
--
--		undo "Mirror X" on
--			mirrorSelection(#PIVOT)(#COPY)
--	)
--)
