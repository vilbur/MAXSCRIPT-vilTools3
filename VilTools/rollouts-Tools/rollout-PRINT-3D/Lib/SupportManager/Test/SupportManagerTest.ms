clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SupportManager.ms" )	-- "./../SupportManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/inlcudes/create-test-objects.ms" )	--"./inlcudes/create-test-objects.ms"


/*------------------------------------------------------------------------------

	 DIFFERENT SETUP OF SCENE UNITS

--------------------------------------------------------------------------------*/

/* UNITS MILLIMETERS */
--units.SystemType	= #millimeters
--units.MetricType	= #millimeters
--EXPORT_SIZE	= 1


/* UNITS MILLIMETERS, DISPLAY CENTIMETERS */
units.SystemType	= #millimeters
units.MetricType	= #centimeters
EXPORT_SIZE	= 1



/* EXPORT SIZE */
--units.SystemType	= #centimeters
--units.MetricType	= #centimeters
--EXPORT_SIZE	= 0.01


/*------------------------------------------------------------------------------

	PREPARE TEST OBJECTS


--------------------------------------------------------------------------------*/

/* ALL VERTS - NO SELECTION OR VERTEX COLOR */
 --createSourceMesh segments:2
 --createSourceMesh segments:8 obj:#SPHERE
-- createSourceMesh segments:4 obj:#BOX


/* VERTICES SELECTED */
--createSourceMesh segments:256 vertex_selection:#{3..4}
--createSourceMesh segments:256 obj:#SPHERE vertex_selection:#{1..1000}
-- createSourceMesh segments:12 obj:#SPHERE vertex_selection:#{32}


/* VERTEX COLOR */
--createSourceMesh segments:2 vertex_color:orange vertex_selection:#{2..3}
--createSourceMesh segments:12 vertex_color:orange vertex_selection:#{2..17} obj:#SPHERE


/* TEST ON TRANSFORMED OBJECT - test  of vertex postion */
--createSourceMesh segments:1 test_shifted_pivot:true


/* SPLINE object as source for supports  */
--createSourceSpline()


/* POINTS object as source for supports */
--createSourcePoints()



/*------------------------------------------------------------------------------
	SET SOURCE OBEJCTS - IMPORTANT: ALL TESTS NEED IT
--------------------------------------------------------------------------------*/
--source_objects = selection as Array
source_objects = objects[1]


/*==============================================================================

		CREATE INSTANCE OF TESTED CLASS

================================================================================*/
--SupportManager 	= SupportManager_v bind_to_parent:true
SupportManager 	= SupportManager_v EXPORT_SIZE:EXPORT_SIZE


format "SupportManager.options	= % \n" SupportManager.options

/*==============================================================================

		RUN POINTS TEST

================================================================================*/

/* 1) GENERATE POINTS FROM SOURCE OBJECT */
--new_ponts = SupportManager.generatePointHelpers( source_objects )
--format "NEW_PONTS	= % \n" new_ponts

--points_by_object = SupportManager.getAllPointsByObject( source_objects )




/* GENERATE NEW PALTFROMS */
--new_platforms = SupportManager.createSupports( source_objects )

--format "new_platforms	= % \n" new_platforms
--
--format "points_by_object	= % \n" points_by_object
--
--move points_by_object[points_by_object.keys[1]] [0,0,-20]




/*------------------------------------------------------------------------------

	GENERATE PALFORMS WITH CROSS SECTION

--------------------------------------------------------------------------------*/
