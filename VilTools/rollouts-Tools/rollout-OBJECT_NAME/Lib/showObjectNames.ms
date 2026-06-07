
global OBJS_TO_DISPLAY_NAMES

unregisterRedrawViewsCallback displayObjectNames
unregisterRedrawViewsCallback displayObjectNamesOnClass

function displayObjectNames filter_classof:undefined use_only_selected:false =
(
	
	/* Get world bounding box center of node.
	   Uses nodeGetBoundingBox in world space. */
	function getNodeBoundingBoxCenter node_object =
	(
		/* Get center position from bounding box array.
		   bounding_box must be #(min_point3, max_point3). */
		function getBoundingBoxCenter bounding_box =
		(
			if ((classOf bounding_box == Array) and (bounding_box.count >= 2)) then
			(
				((bounding_box[1] + bounding_box[2]) * 0.5) -- return
			)
			else
			(
				undefined -- return
			)
		)
		if (isValidNode node_object) then
		(
			bounding_box = nodeGetBoundingBox node_object (matrix3 1)
			getBoundingBoxCenter bounding_box -- return
		)
		else
			undefined -- return
	)
		
	
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
	_objs = for obj in objects where not obj.isHiddenInVpt collect obj
		
		
	if filter_enabled then
		_objs = for obj in objects where not obj.isHiddenInVpt and ( not filter_enabled  or ( filter_enabled and findItem filter_classof (classOf obj) > 0 ) ) collect obj
	
	
	if use_only_selected and OBJS_TO_DISPLAY_NAMES == undefined then
		_objs = OBJS_TO_DISPLAY_NAMES = selection as Array
	
	--format "OBJS_TO_DISPLAY_NAMES: %\n" OBJS_TO_DISPLAY_NAMES
	for obj in _objs do
	(
		--gw.text obj.pos (obj as string ) color:yellow
	  --gw.enlargeUpdateRect #whole

		display_text = toUpper( obj.name as string )
	 
		--text_pos = getNodeViewport2DPos obj text:display_text
		--text_pos = obj.pos
		text_pos = if ( bbox_center =  getNodeBoundingBoxCenter obj ) != undefined then bbox_center else obj.pos
		
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
	
	--displayObjectNames filter_classof:( for obj in selection collect classOf obj )
	displayObjectNames use_only_selected:true
)
