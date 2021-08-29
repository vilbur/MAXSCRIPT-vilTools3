filein( getFilenamePath(getSourceFileName()) + "/../Modifier.ms" )
clearListener()



/** Create test objects
 */
function createTestObjects =
(
	delete (for obj_old in objects collect obj_old)
	
	obj_types	= #( "box", "sphere", "cylinder", "teapot" )
	objs_created = #()
	pos_y = 0
	
	for o in obj_types do 
	(
		
		obj = execute (o+" pos:[0, "+pos_y as string +", 0] wirecolor:" + (color 8 (random 32 128) (random 32 128)) as string )
		
		append objs_created obj
		
		pos_y += 100
	--	maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
	--	select nnl
	--	$.wirecolor = (color (random 128 200) (random 128 200) (random 128 200))
	--	
	--	
	--	move $ [50, 0,0]
	--		
	--	for i = 1 to 5 do
	--	(
	--		maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
	--		move $ [50, 0,0]
	--	)
	--	
	)
	
	select objs_created
	
	/** Randomize selection
	 */
	--step = 2
	--select (for obj in selection where random 1 step == step collect obj)
	deselect selection[1]
	
	modPanel.addModToSelection (Edit_Poly ()) ui:on
		
)


/** Get objects in selection sharing instance of modifier

  
https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_BC52D8A4_E491_4AF8_B0FC_CB1A07561EF4_htm
 */
function getInstancesInSelectionTest =
(
	current_modifier	= modPanel.getCurrentObject()
	instaneces_in_selection	= (Modifier_v()).getObjectsWithInstance selection	current_modifier
	
	print ( "instaneces_in_selection = " + instaneces_in_selection as string )
)

/** Get objects in all objects sharing instance of modifier
 */
function getInstancesInObjectsTest =
(
	current_modifier	= modPanel.getCurrentObject()
	--modifier_id = modPanel.getModifierIndex $ current_modifier 

	--format "modifier_id = % \n" modifier_id 
	
	instaneces_in_objects	= (Modifier_v()).getObjectsWithInstance objects	current_modifier
	
	print ( "instaneces_in_objects = " + instaneces_in_objects as string )
	
	select instaneces_in_objects
)

/*---------------------------------------
	RUN TESTS
-----------------------------------------*/

--createTestObjects()
--getInstancesInSelectionTest()
getInstancesInObjectsTest()


	--current_modifier	= modPanel.getCurrentObject()
--format "current_modifier = % \n" current_modifier.segments  
--format "current_modifier = % \n"( (showProperties current_modifier ))
--current_modifier.getProperty()