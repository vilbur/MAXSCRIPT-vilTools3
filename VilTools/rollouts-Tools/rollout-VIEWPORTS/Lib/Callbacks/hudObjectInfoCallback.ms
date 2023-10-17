

/** Hud object info callback
  *
  */
function hudObjectInfoCallback =
(
	--format "\n"; print "hudMaxInfoCallback.ms.hudMaxInfoCallback()"

	/** Test if objects in sele3ction has locked transfroms
	  *
	  */
	function getLockedTransfroms =
	(
		--format "\n"; print "hudObjectInfoCallback.ms.getLockedTransfroms()"
		state = "LOCKED"

		for obj in selection where ((getTransformLockFlags obj) as Array ).count != 9  do
			state = ""

		state --return
	)


	/*------ HUD ------*/
	HUD = Hud_v pos:#( #LEFT, #CENTER ) callback:hudObjectInfoCallback

	/* CURRENT LAYER */
	HUD.row ( getLockedTransfroms() ) color:orange

	/* SET DATA TO HUD */
	HUD_DATA[#OBJ_INFO] = HUD

)
