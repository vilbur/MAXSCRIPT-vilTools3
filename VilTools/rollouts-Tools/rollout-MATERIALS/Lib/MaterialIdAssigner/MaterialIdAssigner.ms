


/** Material id assigner
 */
struct MaterialIdAssigner_v
(
	/* construct */


	/* properties */
	id,
	obj,
	_mod,

	/* dependency */
	/* reference */
	/* inhered */

	/** Set mat id
	  *
	  */
	function setMatId obj id =
	(
		--format "\n--------------\n"; print "MaterialIdAssigner_v.setMatId()"
		--format "OBJ:	% \n" obj.name
		--format "\n"

		this.obj	= obj

		this.id	= id

		if superClassOf obj.baseobject != shape then
		(
			if ( this._mod = modPanel.getCurrentObject() ) != undefined then
			(
				global MaterialIdAssignerGlobal = this

				method_name = "_set" + substituteString (( superClassOf obj) as string ) "_" ""

				--format "METHOD_NAME:	% \n" method_name

				if hasProperty this ( method_name ) then
					execute ( "MaterialIdAssignerGlobal."+ method_name + "()" )

				else
					this._setMaterialIdModifier()

				MaterialIdAssignerGlobal = undefined
			)
			else
				messageBox "No mod is active. \n\nMETHOD:\n  MaterialIdAssigner_v.setMatId()" title:"ASSIGN MATERIAL ID ERRROR"
		)
		else
			this._setshape()
	),

	private


	/** Set line
	  *
	  */
	function _setshape =
	(
		format "\n"; print "MaterialIdAssigner_v._setshape()"

		format "classOf obj:	% \n" (classOf obj.baseobject)

		/** Set line
		  *
		  */
		function setSplineShapeMatId =
		(
			format "\n"; print "MaterialIdAssigner_v._setSplineShape()"
			format "this.id:	% \n" this.id

			for spline_index = 1 to numSplines obj do
				for seg_index = 1 to numSegments obj spline_index do
					setMaterialID obj spline_index seg_index this.id

			--this._setEditSpline()
		)

		if classOf this.obj.baseobject != SplineShape then
			(SplineConvertor_v()).convert( this.obj ) -- convert to spline, but props of original shape are saved to userProps, so its convertible back

		setSplineShapeMatId()

	),


	/** Set material id modifier
	  *
	  */
	function _setMaterialIdModifier =
	(
		format "\n"; print "MaterialIdAssigner_v._setMaterialIdModifier()"

		if classOf this._mod != Materialmodifier then
			modPanel.addModToSelection (Materialmodifier materialID:id ) ui:on

		else
			this._mod.materialID = id
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "MaterialIdAssigner.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		max modify mode

	)
)
