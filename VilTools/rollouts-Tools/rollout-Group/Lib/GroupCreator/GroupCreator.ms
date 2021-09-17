
/** Group creator
 */
struct GroupCreator_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	_selection,
	_group,
	
	/** _get selection
	 */
	function _getSelection =
	(
	
	
		--lastSelLayer = firstSel.layer		
		--lastSelLayer.addnode _group
		
		
		--setGroupOpen _group false

		
		--select _group
	
	),
	
	/** Create group
	 */
	function createGroup _objects =
	(
			_group = group _objects name:(_objects[1].name + "_Group") select:true

	),
	
	
	function setPivotByFirstObject  = 
	(	
		print "Group_PivotByObject_v"

		
		memberPos = #()
		memberRot = #()
		GroupMembers = #()
		
		TheGroup  = (for g in selection where isgrouphead g collect g)
		TheGroup = TheGroup[1]
		
		obj  = (for o in selection where isgrouphead o == false  collect o)
		obj = obj[1]	
		
		if TheGroup != undefined and obj != undefined then
		(
			if isOpenGroupHead  TheGroup then TheGroupOpened = true
			else (setGroupOpen TheGroup true ; TheGroupOpened = false) 
			
			objPivot = obj.pivot
			objPos = obj.pos
			objRot = obj.rotation
			
				
			for m=1 to TheGroup.children.count where isGroupMember TheGroup.children[m] do
			(
				GroupMembers[m] = TheGroup.children[m]
				memberPos[m] = TheGroup.children[m].pos
				memberRot[m] = TheGroup.children[m].rotation
			)

			TheGroup.pos =  objPos
			TheGroup.rotation = objRot
			
			for m=1 to GroupMembers.count do
			(
				GroupMembers[m].pos = memberPos[m]
				GroupMembers[m].rotation = memberRot[m]
				
-- 			m+=1
			)
			
				
			for m=1 to GroupMembers.count do
			(
				GroupMembers[m].pos = memberPos[m]
				GroupMembers[m].rotation = memberRot[m]
				
				
				
-- 			m+=1
			)
			
			
			TheGroup.pivot =  objPivot			

			
		)	
		
	),	


	/**  
	 */
	on create do
	(
		if selection.count < 2 do
			return false
		
		this.createGroup (_selection = for o in selection collect o)

		this.setPivotByFirstObject()
	)
	
)

