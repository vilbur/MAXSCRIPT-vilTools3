
unregisterRedrawViewsCallback displayObjectNames
unregisterRedrawViewsCallback displayObjectNamesOnClass

function displayObjectNames filter_classof:undefined =
(
	/* Get 2D viewport position from object position
	   Optional corner defines which text corner is anchored to object position. */
	function getNodeViewport2DPos _node text:"" corner:#leftBottom offset:[0,0,0] =
	(
		screen_pos = gw.wTransPoint _node.pos
		result_pos = [screen_pos.x, screen_pos.y, 0]
	
		if text != "" then
		(
			text_size = gw.getTextExtent text
	
			case corner of
			(
				#leftBottom:	result_pos = result_pos
	
				#leftTop:	result_pos.y -= text_size.y
	
				#rightBottom:	result_pos.x -= text_size.x
	
				#rightTop:
				(
					result_pos.x -= text_size.x
					result_pos.y -= text_size.y
				)
	
				#center:
				(
					result_pos.x -= (text_size.x * 0.5)
					result_pos.y -= (text_size.y * 0.5)
				)
	
				#centerBottom:
				(
					result_pos.x -= (text_size.x * 0.5)
				)
	
				#centerTop:
				(
					result_pos.x -= (text_size.x * 0.5)
					result_pos.y -= text_size.y
				)
			)
		)
	
		result_pos += offset
	--format "result_pos: %\n" result_pos
		result_pos -- return
	)
	
	
	
	--format "filter_classof: %\n" filter_classof
	--gw.setTransform ( Matrix3 1)

	filter_enabled = classof filter_classof == Array
	--format "filter_enabled: %\n" filter_enabled
	
	for obj in objects where not obj.isHiddenInVpt and ( not filter_enabled  or ( filter_enabled and findItem filter_classof (classOf obj) > 0 ) ) do
	(
		--gw.text obj.pos (obj as string ) color:yellow
	  --gw.enlargeUpdateRect #whole

		display_text = toUpper( obj.name as string )
	 
		--text_pos = getNodeViewport2DPos obj text:display_text
		text_pos = obj.pos
		--format "text_pos: %\n" text_pos
		if text_pos != undefined then
		(
			/*
				https://forums.cgsociety.org/t/unregister-a-redrawviewscallback-in-scripted-modifier/2048394/4
			*/
			setTransform	= gw.setTransform
			hTransPoint 	= gw.hTransPoint
			--htext	= gw.hText
			htext	= gw.text text_pos display_text color:yellow applyUIScaling:true
			enlargeUpdateRect	= gw.enlargeUpdateRect
			updateScreen	= gw.updateScreen
			
		)


	)
)


/** Display object names on class
 */
function displayObjectNamesOnClass =
(
	--format "\n"; print ".displayObjectNamesOnClass()"
	
	displayObjectNames filter_classof:( for obj in selection collect classOf obj )
)
