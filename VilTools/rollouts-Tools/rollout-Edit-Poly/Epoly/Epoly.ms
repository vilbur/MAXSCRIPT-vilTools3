/** Interface for
 *		- EditablePoly_v
 *		- EditPoly_v
 *
 
	------- DESIGN -- DELTE NOTES BELLOW LATER
	Epoly = Epoly_v()
 
	Selection= Selection_v Epoly:Epoly
 
	Epoly.Mod.FindOrAdd()
	
	Epoly.Selection
	Epoly.Selection.get #face
  
 */
struct Epoly_v
(
	_objects, -- This property is accessed from other classes
	
	--Mod	= EpolyMod_v(),
	--Options	= EpolyOptions_v	Epoly:this,
	--Sel	= EpolySelection_v	Epoly:this,
	--Edit 	= EpolyEdit_v	Epoly:this,
	--SmoothGroups	= EpolySmoothGroups_v	Epoly:this,
	--Edges	= EpolyEdges_v	Epoly:this,
	--Explode	= EditPolyExplode_v	Epoly:this,
	--Material 	= EditPolyMaterial_v	Epoly:this,
	--Subobject 	= EpolySubobject_v	Epoly:this,
	
	/** _construct
	 */
	function _construct =
	(
		--messageBox "_construct" beep:false
		this.setObjects()
	),


	/*------------------------------------------------------------------------------
		PRIVATE
	--------------------------------------------------------------------------------*/
	/** _objects
	 */
	function obj =
	(
		_objects[1] --return
	),	
	/** _objects
	 */
	function objs =
	(
		_objects --return
	),	
	
	/** Set selection of objects
	 */
	function setObjects =
	(
		_objects	= for obj in selection where superClassOf obj == GeometryClass collect obj
		--_objects = (Selection_v()).get() -- THIS METHOD WILL BE USED, IT WILL FILTER INSTANCES
	),
	
	
	
	
	
	__construct = this._construct(),

	
	
	on craete do
	(
		
	)
	
	
)

