/** Edit poly
 */
struct EditPolyExplode_v
(
	_selection,

	Epoly,

	final_sel = #(),

	/** Explode
	  * @param	[bitArray]	poly_selections	Array of bitarrays to detach
	  * @return	selection
	  *
	 */
	function explode obj poly_selections =
	(
		print ( "EditPolyExplode_v.explode() poly_selections=" + poly_selections as string )
		final_sel = #()

		for poly_selection in poly_selections do
			this._detach obj poly_selection

		--print ( "final_sel=" + final_sel as string )
		final_sel --return
		--append final_sel detObj
	),

	/** Explode each object
	 */
	function explodeEachObject explode_method =
	(
		--_selection = (Selection_v()).get()
		max create mode
		

		for obj in _selection do
		(
			instances = this._getInstances (obj)

			maxOps.CollapseNode obj off

			case explode_method of
			(
				"getElements":	poly_selections = this.getElements obj
				"_getSmoothGroups":	poly_selections = this._getSmoothGroups obj
				"_getMaterialElements":	poly_selections = this._getMaterialElements obj
				--"explodeByHardEdges":	poly_selections = this.explodeByHardEdges obj
			)

			exploded_objects = this.explode (obj) (poly_selections)

			if instances.count > 0 then
				this._reInstanceObjects (exploded_objects)(instances)

			delete obj
		)
	),

	/** Re instance
	 */
	function _reInstanceObjects exploded_objects instances =
	(
		--format "\n"; print "EditPolyExplode_v._reInstance()"
		for exploded_object in exploded_objects do
		(
			maxOps.cloneNodes instances cloneType:#copy newNodes:&instances_copy

			for instance_copy in instances_copy do
				instanceReplace instance_copy exploded_object

			instances_copy.wirecolor = exploded_object.wirecolor
		)

		delete instances
	),

	/** Get instances
	 */
	function _getInstances obj =
	(
		format "\n"; print "EditPolyExplode_v._getInstances()"
		instances = #()

		InstanceMgr.GetInstances obj &instances

		for inst in instances where  inst != obj collect inst  --return
	),

	/** Explode all elements
	 */
	function explodeByElement =
	(
		--this._setObj()
		this.explodeEachObject "getElements" --return
		--this.explode ( this.getElements() ) --return
		final_sel --return

	),

	/**  Explode all smoothgroups
	 */
	function explodeBySG =
	(
		this.explodeEachObject "_getSmoothGroups" --return

		final_sel --return
		--this.explode ( _getSmoothGroups() ) --return
	),

	/** Explode by material id
	 */
	function explodeByMaterialId =
	(
		this.explodeEachObject "_getMaterialElements" --return
		--this.explode ( this._getMaterialElements() ) --return
		final_sel --return
	),
	/**
	 */
	function explodeByHardEdges =
	(
		--this.selectHardEdges()
		EpolyEdges = EpolyEdges_v()
		EpolyEdges.selectHardEdges obj
		EpolyEdges.splitEdges()

		this.explodeByElement() --return

		--#(obj)
		--undefined --return
		final_sel --return
	),
	/** Get elements
	 */
	function getElements obj =
	--function getElements _obj =
	(
		--print "getElements"
		--print ( "this = " + this as string )
		--print this
		--print ( "obj = " + obj as string )
		faces	= #{}
		obj_faces	= this._allFaces obj

		getElement = polyop.getElementsUsingFace

		elements = for i in obj_faces where obj_faces[i] == true collect
		(
			element = getElement obj i
			obj_faces -= element
			element
		)

		elements --return
	),

	/** Get material elements
	  * @return	[bitArray]	Array of faces by material
	 */
	function _getMaterialElements obj =
	(
		all_ids	= #()
		material_faces	= #();

		--print "_getMaterialElements"
		for f=1 to polyop.getNumFaces obj do
			appendIfUnique all_ids ( polyop.getFaceMatID obj f)

				id = 1
		for id in all_ids do
			append material_faces ((for f=1 to polyop.getNumFaces obj where polyop.getFaceMatID obj f == id collect f) as bitarray)

		material_faces --return
	),

	/** Get smooth groups
	 */
	function _getSmoothGroups obj =
	(
		smooth_groups = #()
		maxops.CollapseNode obj off
		--smGroupsArray = polyop.getFaceSmoothGroup obj firstFace;
		face_num = polyop.getNumFaces obj

		for sg_id = 1 to 32 do
		(
			smooth_group_face = #()

			for f=1 to face_num do
			--(
				if (( polyop.getFaceSmoothGroup obj f) == sg_id) then
					append smooth_group_face f
			--)
			--smooth_group_face = smooth_group_face as bitArray

			print ( "smooth_group_face=" + smooth_group_face as string )
			if  (  smooth_group_face.count > 0 and ( (smooth_group_face as array)[1] == 1 and smooth_group_face.count == face_num)==false ) then
				append smooth_groups smooth_group_face
		)
		smooth_groups --return
	),

	/** Set obj
	 */
	function _setObj =
	(
		--_selection = (Selection_v()).get()

		obj	= _selection[1]
	),

	/** _all faces
	 */
	function _allFaces obj =
	(
		#{1..( polyop.getNumFaces obj)} --return
	),

	/** Detach
	 */
	function _detach obj poly_selection =
	(
		--print ( "obj = " + obj as string )
		polyop.detachFaces obj poly_selection delete:false asNode:true name: "TempDet"

		detObj = getnodebyname "TempDet"
		detObj.name = (uniquename (obj.name + "_detach"))
		detOBj.wirecolor =  color (random 0 255) (random 0 255) (random 0 255)

		append final_sel detObj
	),

	/**
	 */
	on create do
	(
		if Epoly == undefined then
			Epoly = modPanel.getCurrentObject()
	)
)
