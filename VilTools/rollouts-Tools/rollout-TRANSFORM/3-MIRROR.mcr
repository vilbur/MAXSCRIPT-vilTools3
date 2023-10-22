filein( getFilenamePath(getSourceFileName()) + "/Lib/MirrorByGizmo/MirrorByGizmo.ms" )	-- "./Lib/MirrorByGizmo/MirrorByGizmo.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/MirrorRestore/MirrorRestore.ms" )	-- "./Lib/MirrorRestore/MirrorRestore.ms"

/**
  */
macroscript	selection_mirror_instance
category:	"_Mirror"
buttontext:	"Mirror Instance"
toolTip:	"Mirror instances.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP.\n\nMirrored objects keeps data about mirroring in user properties"
icon:	"MENU:true"
(
	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\3-MIRROR.mcr"

		undo "Mirror" on
			select ((MirrorByGizmo_v()).mirrorObjects( selection )(#INSTANCE))
	)
)

/**
  */
macroscript	selection_mirror_copy
category:	"_Mirror"
buttontext:	"Mirror Copy"
toolTip:	"Mirror copy.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP.\n\nMirrored objects keeps data about mirroring in user properties"
icon:	"MENU:true"
(
	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\3-MIRROR.mcr"

		undo "Mirror" on
			select ((MirrorByGizmo_v()).mirrorObjects( selection )(#COPY))
	)
)

/**
  */
macroscript	selection_mirror_restore
category:	"_Mirror"
buttontext:	"Restore Mirrors"
toolTip:	"Restore mirroring of selected objects by data in user properties.\n\nIF NOTHING SELECTED, THEN ALL OBJECTS IN SCENE ARE RESTORED"
icon:	"MENU:true"
(
	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\3-MIRROR.mcr"

		undo "Restore Mirrors" on
		(
			objects_to_search_for_restore =  if selection.count > 0 then selection else objects

			restored_mirrors = (MirrorRestore_v()).restoreMirrors( objects_to_search_for_restore )

			select restored_mirrors
		)
	)
)

/**
  */
macroscript	selection_mirror_get_source_objects
category:	"_Mirror"
buttontext:	"Get Source Objects"
toolTip:	"Get source objects of mirrorred objects"
icon:	"MENU:true"
(
	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\3-MIRROR.mcr"

		undo "Restore Mirrors" on
		(
			objects_to_search = if selection.count > 0 then selection else objects

			source_objects = (MirrorByGizmo_v()).getSourceObjects( objects_to_search )

			select source_objects
		)
	)
)





--  */
--macroscript	selection_mirror_copy
--category:	"_Mirror"
--buttontext:	"Copy By Wolrd"
--toolTip:	"Mirror Copy by pivot axis.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP"
--icon:	"MENU:Mirror Copy By Wolrd"
--(
--	on execute do
--	(
--		--clearListener(); print("Cleared in:\n"+getSourceFileName())
--		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\MIRROR.mcr"
--
--		undo "Mirror X" on
--			mirrorObjects( selection )(#WORLD)(#COPY)
--	)
--)

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
--		--clearListener(); print("Cleared in:\n"+getSourceFileName())
--		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"
--
--		undo "Mirror X" on
--			mirrorObjects( selection )(#PIVOT)(#INSTANCE)
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
--		--clearListener(); print("Cleared in:\n"+getSourceFileName())
--		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"
--
--		undo "Mirror X" on
--			mirrorObjects( selection )(#PIVOT)(#COPY)
--	)
--)
