/** Filter selection or set filter
  
	A) If selection exist then filter only objects of given type
	
	B) If selection OT exist then set filter of given type https://help.autodesk.com/view/3DSMAX/2026/ENU/?guid=GUID-012FDAE2-660A-45E3-9AAB-BB65CD801652
	
	@param name	type:	#All
			#Geometry
			#Shapes
			#Lights
			#Cameras
			#Helpers
			#Warps
			#Bone
			#IKChainObject
			#Point
			#CATBone
	  
  
	--filter_id:
	--	1: All
	--	2: Geometry
	--	3: Shapes
	--	4: Lights
	--	5: Cameras
	--	6: Helpers
	--	7: Warps
	--	8: Bone
	--	9: IK Chain Object
	--	10: Point
	--	11: CAT Bone
  
  
 --*/
function filterSelectionOrSetFilter type:#ALL =
(
	format "\n"; print ".filterSelectionOrSetFilter()"
	format "type: %\n" type
	
	objs_to_deselect = #()
	
	filter_ids =
	#(
		#All,
		#Geometry,
		#Shape,
		#Light,
		#Camera,
		#Helper,
		#Warp,
		#Bone,
		#IKChainObject,
		#Point,
		#CATBone
	)
		
	/*------------------------------------------------------------------------------
		FILTER IN CURENT SELECTION
	--------------------------------------------------------------------------------*/
	
	if selection.count > 0 and ( type != #IKChainObject or type != #CATBone ) then
	(
		filtered_class = case type of
		(
			#Geometry	: GeometryClass
			#Shape	: shape
			#Light	: light
			#Camera	: camera
			#Helper	: helper
			#Warp	: SpacewarpObject
			#Bone	: GeometryClass
			#IKChainObject	: helper
			#Point	: helper
			#CATBone	: GeometryClass	
		)
		
		for obj in selection do
		(
			deselect_obj = superClassOf obj != filtered_class
			
			/* EXCEPTION FOR SHARE TYPE ( E.G.: POINT is also HELPER  ) */ 
			if not deselect_obj then
				deselect_obj = case type of
				(
					#Geometry: classOf obj == BoneGeometry
					
					#Bone: classOf obj != BoneGeometry
					
					#Point: classOf obj != Point
					
					
					default: false
				)
				
			format "deselect_obj: %\n" deselect_obj
			
			if deselect_obj then
				append objs_to_deselect obj
		)
		
		deselect objs_to_deselect
		
	)

	/*----------------------------------------------------------------------------------------------------------------------------------------------------
		SET FILTER FOR SELECTION https://help.autodesk.com/view/3DSMAX/2026/ENU/?guid=GUID-012FDAE2-660A-45E3-9AAB-BB65CD801652
	------------------------------------------------------------------------------------------------------------------------------------------------------*/
	else if ( filter_id = findItem filter_ids type ) > 0 then
	(
		/* SET DESIRED FILTER OR RESET TO FILTER #ALL */ 
		if GetSelectFilter() != filter_id then SetSelectFilter filter_id else SetSelectFilter 1
	)
	
	
)