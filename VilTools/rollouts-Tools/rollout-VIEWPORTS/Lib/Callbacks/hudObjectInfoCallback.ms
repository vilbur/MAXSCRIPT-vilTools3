

/** Hud object info callback
  *
  */
function hudObjectInfoCallback =
(
	--format "\n"; print "hudMaxInfoCallback.ms.hudMaxInfoCallback()"

	/** Test if objects in selection has locked transfroms
	  *
	  * https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-8EB13535-72B4-439C-94D3-E93434BA163B
	  */
	function getLockedTransfroms =
	(
		--format "\n"; print "hudObjectInfoCallback.ms.getLockedTransfroms()"
		state = if selection.count > 0 then "L O C K E D" else ""

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
