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



/** Get objects in all objects sharing instance of modifier
 */
function getInstancesInObjectsTest =
(
	
	Modifier 	= Modifier_v()
	
	Modifier.setCurrent()
	
	instaneces_in_objects	= Modifier.getObjectsWithInstance objects
	
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