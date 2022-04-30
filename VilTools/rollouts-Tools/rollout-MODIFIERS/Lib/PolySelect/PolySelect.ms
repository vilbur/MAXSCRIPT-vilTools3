/** Poly select https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_49746C1B_AA59_481D_BEFF_BDFCC78CBFA1_htm
  * 
  * 
  * 
 */
struct PolySelect_v
(
	--__construct = #( #obj ),
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	obj,
	--_modifier,
	
	indexes	= #(), -- indexes of Poly_Select modifiers in stack
	
	face_ids	= #(), -- 2D matrix of material id and face ids E.G.: #( #(<mat_id>, #{<face_ids_bitarray>}), #(2, #{2..99})) 

	/** Update Object
	  *
	  * 1) Search for Poly_Select modifiers on object
	  * 2) Add temporary Edit_Poly modifier under Poly_Select
	  * 3) Make selection on Edit_Poly modifier
	  * 4) Add new Poly_Select modifier
	  * 5) Delete old Poly select modifier
	  *
	 */
	function updateObject obj =
	(
		--format "\n"; print "PolySelect_v.updateObject()"
		this.obj = obj
		
		this._getModifiersIndex()
		
		--format "indexes	= % \n" indexes
		
		undo "Update Poly Select" on

		for index in indexes do 
			this._updatePolySelect(index)
		
		
		--format "_modifier	= % \n" _modifier
		--format "classOf _modifier	= % \n" (classOf _modifier) 
		--
		--mat_id = this._getProperty(#materialID)
		--
		--format "mat_id	= % \n" mat_id
		--_modifier.name = "Select - Mat " + mat_id as string 
	
		
	),
	
	
	private
	
	
	/** _update modifier
	 */
	function _updatePolySelect index =
	(
		format "\n"; print "PolySelect_v._updatePolySelect()"
		
		modPanel.setCurrentObject obj.modifiers[index]
		PolySelectOld	= modPanel.getCurrentObject()
		
		mat_id_for_select	= (this._getProperty PolySelectOld #materialID) as integer
		
		format "mat_id_for_select	= % \n" mat_id_for_select
		this._selectModUnderPolySelect(index)
		
		EditPolyTemp = this._addTempEditPoly()

		face_ids = this._getFacesByMatID()

		this._selectFacesByMaterialId(EditPolyTemp)(mat_id_for_select)
		
		
		PolySelectNew = this._addPolySelectNew( "Select Mat ID "+mat_id_for_select as string )

		
		PolySelectNew.materialID = mat_id_for_select

		
		deleteModifier obj EditPolyTemp
		deleteModifier obj PolySelectOld
	),
	
	/** Get material ids of faces for current mod
	  *	
	  */
	function _getFacesByMatID =
	(
		ids=#{}
		faces=#()
		
		for f = 1 to polyop.getNumFaces obj do
		(
			id = polyop.getFaceMatID obj f
	
			if not ids[id] then faces[id]=#{f} else faces[id][f]=true; ids[id]=true
		)

		for id in ids collect #(id, faces[id]) --return 
	),
	

	/** _select faces by material id
	 */
	function _selectFacesByMaterialId EditPoly id =
	(
		format "\n"; print "PolySelect_v._selectFacesByMaterialId()"
		local faces
		
		for matrix in face_ids where matrix[1] == id  do --TODO: change "matrix" to something more reasonable
			faces = matrix[2]
		
		subObjectLevel = 4

		if( faces != undefined ) then
		(
			EditPoly.SetSelection	#Face #{}	-- clear selection
			EditPoly.Select	#Face faces	
		)

		else
			messageBox ("material ID: "+ id as string + " is not defined") title:"Warning"  beep:false
	), 

	/** Get indexes of Poly Select modifiers on object
	 */
	function _getModifiersIndex =
	(
		format "\n"; print "PolySelect_v._getModifiersIndex()"
		
		indexes = for i = obj.modifiers.count to 1 by -1 where classOf obj.modifiers[i] == Poly_Select collect i
		
	),
	
	/** _select modifier under poly select
	 */
	function _selectModUnderPolySelect index =
	(
		--format "\n"; print "PolySelect_v._selectModUnderPolySelect()"
		if index == obj.modifiers.count then 
			modPanel.setCurrentObject obj.baseObject

		else
			modPanel.setCurrentObject obj.modifiers[index+1]
	),
	
	/** _add temp edit poly
	  *
	  * @return	modifier Edit_Poly	
	 */
	function _addTempEditPoly =
	(
		--format "\n"; print "PolySelect_v._addTempEditPoly()"
		EditPolyTemp = Edit_Poly name:"EditPolyTemp"
		
		modPanel.addModToSelection EditPolyTemp ui:on
		
		EditPolyTemp --return
	),
	
	/** Add new Poly_Select modifier 
	  *
	  * @return	modifier Poly_Select	
	 */
	function _addPolySelectNew modifier_name =
	(
		--format "\n"; print "PolySelect_v._addTempEditPoly()"
		PolySelectNew = Poly_Select name:modifier_name
		
		modPanel.addModToSelection PolySelectNew ui:on
		
		subObjectLevel = 4

		PolySelectNew --return
	),
	
	/** Get properties
	 */
	function _getProperty _modifier prop_name =
	(
		--format "\n"; printq "PolySelect_v._getProperty()"
		if _modifier != undefined then 
			getProperty _modifier prop_name --return
	),
	
	/** Get properties
	 */
	function _setProperty _modifier prop_name val =
	(
		--format "\n"; printq "PolySelect_v._getProperty()"
		if _modifier != undefined then 
			setProperty _modifier prop_name val --return
	),
	--/** Get poly select modifier
	-- */
	--function _getPolySelectModifier =
	--(
	--	--format "\n"; print "PolySelect_v.getPolySelectModifier()"
	--	for obj_modifier in obj.modifiers do
	--		if( classOf obj_modifier == Poly_Select ) then 
	--			_modifier = obj_modifier
	--),

	--/** Get properties
	-- */
	--function _getProperties =
	--(
	--	format "\n"; print "PolySelect_v._getProperties()"
	--	_modifier = modPanel.getCurrentObject()
	--
	--	if _modifier != undefined then 
	--		for prop in getPropNames _modifier do
	--		(
	--			value	= getProperty _modifier prop
	--			
	--			format "prop	= % \n" prop
	--			format "% = % \n" prop value
	--			
	--		)
	--),
	
	/**  
	 */
	on create do
	(
		--print("PolySelect_v.onCreate()")
	)
	
)
