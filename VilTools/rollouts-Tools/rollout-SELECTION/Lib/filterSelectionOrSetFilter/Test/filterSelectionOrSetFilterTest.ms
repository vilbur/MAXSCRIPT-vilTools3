clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../filterSelectionOrSetFilter.ms" )	--"./../filterSelectionOrSetFilter.ms"


function createTestNodes =
(
	nodes_arr = #()

	offset = 0
	
	function nextPos &offset =
	(
		offset += 30
		
		
		[offset,0,0] --return
	)
	
	delete objects
	
	/* Geometry */
	append nodes_arr (box name:"test_box"  pos:(nextPos(&offset)) )
	
	/* Shapes */
	append nodes_arr (circle name:"test_circle"  pos:(nextPos(&offset)) )
	
	/* Lights */
	append nodes_arr (omniLight name:"test_light"  pos:(nextPos(&offset)) )
	
	/* Cameras */
	append nodes_arr (freeCamera name:"test_camera"  pos:(nextPos(&offset)) )
	
	/* Helpers */
	append nodes_arr ( Dummy name:"test_dummy"  pos:(nextPos(&offset)) )
	
	/* Warps (Spacewarp) */
	append nodes_arr (gravity name:"test_gravity"  pos:(nextPos(&offset)) )
	
	/* Bone */
	bone_obj = boneSys.createBone [0,0,0] [10,0,0] [0,0,1]
	bone_obj.name = "test_bone"
	append nodes_arr bone_obj
	
	 /*Point (explicit test) */
	append nodes_arr ( point name:"test_point"  pos:(nextPos(&offset)) )
	
	
	nodes_arr -- return
)

/*------------------------------------------------------------------------------
	PREPARE TEST
--------------------------------------------------------------------------------*/

createTestNodes()

select objects

/*------------------------------------------------------------------------------
	RUN TESTS
--------------------------------------------------------------------------------*/
--filterSelectionOrSetFilter type:#GEOMETRY
--filterSelectionOrSetFilter type:#POINT
--filterSelectionOrSetFilter type:#SHAPE
--filterSelectionOrSetFilter type:#HELPER
--filterSelectionOrSetFilter type:#BONE
--filterSelectionOrSetFilter type:#LIGHT
--filterSelectionOrSetFilter type:#CAMERA
--filterSelectionOrSetFilter type:#WARP

/* TYPES BELLOW ONLY SET FILTER */ 
--filterSelectionOrSetFilter type:#CATBone
--filterSelectionOrSetFilter type:#IKChainObject



