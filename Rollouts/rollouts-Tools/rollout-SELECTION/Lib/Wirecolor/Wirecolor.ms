filein( getFilenamePath(getSourceFileName()) + "/../../../../../Lib/Color/Color.ms" )

/** Set wirecolor to obejcts
  * 
  * Instances has same wirecolor
  * 
  * Selection is used if property nodes is not defined
  * 
  * @property	array	nodes	objects where wirecolor will be changed, current selection is used if undefined
  * @property	undefined|#random|#instance mode
  *	undefined:	set same wirecolor for all objects
  *	#random:	set different wirecolor to each object
  *	#instance:	random color for unique objects, but same for instances of obejcts
 */
struct Wirecolor_v
(
	/* construct */

	/* properties */
	mode,
	nodes,

	/* dependency */
	/* reference */
	/* inhered */

	nodes_prepared = #(),

	/** Randomize
	  * 
	  * @param	array|colelction	nodes	for colorize
	 */
	function randomize color_name: hue:128 brightness:#(64, 255) saturation:#(64, 255) =
	(
		--format "\n"; print "Wirecolor_v._sortNodesByInstances()"
		case mode of
		(
			undefined:	append nodes_prepared nodes
			#instance:	this._sortNodesByInstances()
			#random:	nodes_prepared = nodes
		)

		for arr in nodes_prepared do
			arr.wirecolor = (Color_v()).randomize color_name:color_name	hue:hue brightness:brightness saturation:saturation
	),

	private

	/** Get instances for each node
	  * 
	  * @return	2D matrix of collections	
	 */
	function _sortNodesByInstances =
	(
		--format "\n"; print "Wirecolor_v._sortNodesByInstances()"
		tested	= #()

		for obj in nodes where findItem tested obj == 0 do 
		(
			local obj_instances

			InstanceMgr.GetInstances obj &obj_instances

			append nodes_prepared obj_instances

			tested = tested + obj_instances
		)

		nodes_prepared --return
	),

	/**  
	 */
	on create do
	(
		--format "\n"; print "Wirecolor.onCreate()"
		if nodes == undefined then
			nodes = selection
	)

)