

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
			
			val	= getUserPropVal $ ( key_val_pair[1] )
			
			--format "val: %\n" val
			--if key_val_pair[2].count > 30 then
			if (val as string ).count > 50 then
			(
				--_line = key_val_pair[1] + substring ( val[1] as string ) 1 50 + " ..."
				if classOf val == Array or classOf val == BitArray then
					_line = key_val_pair[1] + " = "+ val[1] as string + " ..."
				
					--_line = key_val_pair[1] + " = "+ (classOf val) as string +":" + val.count as string
				
			)
			
			HUD.row _line color: white
		)
		
	)
	
	
	/** Test if objects in selection has locked transfroms
	  *
	  * https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-8EB13535-72B4-439C-94D3-E93434BA163B
	  */
	function getLockedTransfroms HUD =
	(
		--format "\n"; print "hudObjectInfoCallback.ms.getLockedTransfroms()"
		--obj	= selection[1]
		
		
		locked_tracks = #( #{}, #{}, #{} )
		
		transform_tracks = #( "POSITION", "ROTATION", "SCALE" )
		
		colors	= #( red, green, color 0 200 255 )
		
		axises = #( "X", "Y", "Z" ) 
		
		
		
		lock_flags = undefined
		
		for obj in selection do
		(
			lock_flags = getTransformLockFlags obj --{POS_X,POS_Y,POS_Z,ROT_X,ROT_Y,ROT_Z,SCALE_X,SCALE_Y,SCALE_Z}
			bit_counter = 0
			
			for x = 1 to 3 do
				for y = 1 to 3 do
					locked_tracks[x][y] = lock_flags[bit_counter +=1]
		)

				
				
		
		if not lock_flags.isEmpty then
		(
			/* TRANSFORM LOCK HEADER */ 
			append HUD.Rows ( HudRow_v columns: #(	HudColumn_v "--- TRANSFORM LOCK ---" ) height:24 color:yellow  )
			
			/* FOR "POSITION" "ROTATION" "SCALE"  */ 
			for i = 1 to locked_tracks.count where locked_tracks[i].numberSet > 0 do 
			(
				Row = HudRow_v columns: #(	HudColumn_v transform_tracks[i] width:64  ) color:colors[i] 
				
				for axis = 1 to 3 do
					Row.column  ( if locked_tracks[i][axis] then axises[axis] else " " ) width:10
				
				append HUD.Rows Row
			
			)
		)

		HUD --return
	)


	/*==============================================================================
		
		CREATE HUD
		
	================================================================================*/
	
	HUD = Hud_v pos:#( #LEFT, #TOP ) offset:[ 0, 32 ] callback:hudObjectInfoCallback

	
	if selection.count > 0 then
	(
		/* OBJECT NAMES */ 	
		for i = 1 to selection.count while i <= 10 do
			HUD.row ( selection[i].name ) color: selection[i].wirecolor
		
		/* SHOW USER PROPS */ 
		if selection.count == 1 then
			splitUserProps(HUD)
			
		/* LOCKED TRANSFORMS */
		HUD = getLockedTransfroms(HUD)
	)



	/* SET DATA TO HUD */
	HUD_DATA[#OBJ_INFO] = HUD

)
