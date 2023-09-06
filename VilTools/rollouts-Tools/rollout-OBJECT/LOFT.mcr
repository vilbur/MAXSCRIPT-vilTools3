
/*
*/
macroscript	_obejct_create_loft
category:	"_Create-Compounds"
buttontext:	"Loft"
toolTip:	"Create Loft"
icon:	"MENU:true"
(

	on execute do
		if selection.count >= 2 then
		(
			clearListener(); print("Cleared in:"+getSourceFileName())
			filein( getFilenamePath(getSourceFileName()) + "/../rollout-MODIFIER-STACK/Lib/LoftRemote/LoftRemote.ms" )	-- "./../rollout-MODIFIER-STACK/Lib/LoftRemote/LoftRemote.ms"

			/* SETUP LOFT */
			LoftRemote 	= LoftRemote_v()

			--LoftRemote.setMethod(3)
			LoftRemote.setMethod(#STEPS)  -- default steps count is intepolation of path
			--LoftRemote.setMethod(#PERCENTAGE)
			--LoftRemote.setMethod(#DISTANCE)


			/* SET SHAPES */
			LoftRemote.setPath	( selection[1] )

			for i = 2 to selection.count do
				LoftRemote.setShape ( selection[ i ]  )	--pos:0

			/* CREATE LOFT */
			LoftRemote.create()
		)

)