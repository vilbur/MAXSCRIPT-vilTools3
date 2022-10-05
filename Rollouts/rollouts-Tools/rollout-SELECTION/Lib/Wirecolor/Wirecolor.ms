filein( getFilenamePath(getSourceFileName()) + "/../../../../../Lib/Color/Color.ms" )

/** Set wirecolor to obejcts
  * 
  * Instances has same wirecolor
  * 
  * Selction is used if property _objects is not defined
 */
struct Wirecolor_v
(
	/* construct */

	/* properties */
	_objects,
	
	/* dependency */
	_Color 	= Color_v(),

	/* reference */
	/* inhered */

	/** Randomize
	  * 
	  * @param	array|colelction	_objects	for colorize
	 */
	function randomize col: hue:0 brightness:255 saturation:255 =
	(
		--_Color.randomize col:col hue:hue brightness:brightness saturation:saturation
		
		for objs in this._sortNodesByInstances (_objects) do
			objs.wirecolor = _Color.randomize col:col hue:hue brightness:brightness saturation:saturation

	),


	private

	/** Get instances for each node
	  * 
	  * @return	2D matrix of collections	
	 */
	function _sortNodesByInstances _objects =
	(
		--format "\n"; print "Wirecolor_v._sortNodesByInstances()"
		instances	= #()
		tested	= #()
		
		for obj in _objects where findItem tested obj == 0 do 
		(
			local obj_instances

			InstanceMgr.GetInstances obj &obj_instances
			
			append instances obj_instances
			
			tested = tested + obj_instances
		)
		
		instances --return
	),

	/**  
	 */
	on create do
	(
		--format "\n"; print "Wirecolor.onCreate()"
		if _objects == undefined then
			_objects = selection
	)

)