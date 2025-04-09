

/** GET DATA FOR 3DS MAX HUD
  *
  */
function hudObjectInfoCallback =
(
	--format "\n"; print "hudMaxInfoCallback.ms.hudMaxInfoCallback()"
	/** Split user props
	 */
	function splitUserProps HUD =
	(
		--format "\n"; print ".splitUserProps()"
		user_prop_buffer	= filterString (getUserPropBuffer $) "\n"
		
		for _line in user_prop_buffer do
		(
			key_val_pair = filterString _line " = "

			if key_val_pair[2].count > 30 then
			(
				val	= getUserPropVal $ ( key_val_pair[1] )
				
				if classOf ( val ) == Array then
					_line = key_val_pair[1] + " = Array:" + val.count as string
				
			)
			
			HUD.row _line color: white
		)
		
	)
	
	
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

	if selection.count > 0 then
	(
		for i = 1 to selection.count while i <= 10 do
		--for obj in selection do
			HUD.row ( selection[i].name ) color: selection[i].wirecolor
			
		if selection.count == 1 then
			splitUserProps(HUD)
			
	)


	/* LOCKED TRANSFORMS */
	HUD.row ( getLockedTransfroms() ) color:orange

	/* SET DATA TO HUD */
	HUD_DATA[#OBJ_INFO] = HUD

)
