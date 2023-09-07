/** Convert shape type object like Rectangle or Circle to
 */
struct SplineConvertor_v
(
	/* construct */


	/* properties */
	obj,

	object_state = Dictionary(),
	modifiers, -- if not empty, then invalid modifiers such Edit_Poly are applied on spline
	state_keys	= #( #name, #transform, #wirecolor, #parent ),

	/* dependency */
	/* reference */
	/* inhered */
	/** Convert
	  *
	  */
	function convert obj =
	(
		--format "\n"; print "SplineConvertor_v.convert()"
		--format "superClassOf obj.baseobject:	% \n" (superClassOf obj.baseobject)
		if superClassOf obj.baseobject == shape then
		(
			current_max_mode = GetCommandPanelTaskMode()

			max create mode

			this.obj = obj

			this._saveProperties()

			this._saveProperties()

			this._saveModifiers()

			this._deleteModifiers()

			this._convertToEdiableSpline()

			this._loadModifiers()

			SetCommandPanelTaskMode (current_max_mode)
		)
	),

	/** Revert
	  *
	  */
	function revert obj =
	(
		--format "\n"; print "SplineConvertor_v.revert()"

		if superClassOf obj.baseobject == shape then
		(
			current_max_mode = GetCommandPanelTaskMode()

			max create mode

			this.obj = obj

			--select this.obj

			converted_from  = this._loadProperty (#converted_from)
			converted_props = this._loadProperty (#converted_props)

			if converted_from == undefined or converted_props == undefined then
				return false

			this._saveObjectState()

			this._createOriginalShape(converted_from)

			this._loadProperties(converted_props)

			this._loadObjectState()

			SetCommandPanelTaskMode (current_max_mode)

		)
	),

	private

	/** Convert to ediable spline
	  *
	  */
	function _convertToEdiableSpline =
	(
		--format "\n"; print "SplineConvertor_v._convertToEdiableSpline()"

		all_modfiers_valid = this.modifiers == undefined

		if all_modfiers_valid then
		(
			addModifier this.obj (Edit_Spline name: "ConvertTo Edit_Spline" ) before:this.obj.modifiers.count

			maxOps.CollapseNodeTo this.obj this.obj.modifiers.count off
		)
		else
			convertTo this.obj SplineShape -- modifiers were saved before
	),

	/** Create original
	  *
	  */
	function _createOriginalShape converted_from =
	(
		--format "\n"; print "SplineConvertor_v._createOriginalShape()"
		--format "converted_from:	% \n" (converted_from)
		new_shape = execute( converted_from as string + "()" )

		--for i = this.obj.modifiers.count to 1 by -1 do
		--	addModifier new_shape this.obj.modifiers[i]
		this._copyModifiers (new_shape)
		--new_shape.modifiers = this.obj.modifiers

		delete this.obj

		this.obj = new_shape
	),
	/** Save properties
	  *
	  */
	function _saveProperties =
	(
		--format "\n"; print "SplineConvertor_v._saveProperties()"

		props_save =  Dictionary()

		for prop in getPropNames this.obj do
			props_save[prop] = getProperty this.obj prop

		--format "\n-----------\nDICTIONARY:props_save:%\n" props_save; for data_pair in props_save do format "%:	%\n" data_pair.key data_pair.value

		this._setProperty #converted_from	(classOf this.obj.baseobject)
		this._setProperty #converted_props	(props_save)
	),

	/** Set properties to object
	  *
	  */
	function _loadProperties converted_props =
	(
		--format "\n"; print "SplineConvertor_v._loadProperties()"
		--format "\n-----------\nDICTIONARY:converted_props:%\n" converted_props; for data_pair in converted_props do format "%:	%\n" data_pair.key data_pair.value

		for data_pair in converted_props do
			 setProperty this.obj data_pair.key data_pair.value
	),

	/** Copy modifiers
	  *
	  */
	function _copyModifiers new_shape =
	(
		--format "\n"; print "SplineConvertor_v._copyModifiers()"

		for i = this.obj.modifiers.count to 1 by -1 do
			addModifier new_shape this.obj.modifiers[i]
	),

	/** Load obejcts state
	  *
	  */
	function _saveObjectState =
	(
		--format "\n"; print "SplineConvertor_v._saveObjectState()"

		object_state	= Dictionary()

		for prop in state_keys do

			object_state[prop] = getProperty this.obj prop

		object_state[#layer] = this.obj.layer

		object_state[#children] = for child in this.obj.children collect child
	),

	/** Save object state
	  *
	  */
	function _loadObjectState =
	(
		--format "\n"; print "SplineConvertor_v._loadObjectState()"
		--format "this.obj:	% \n" this.obj

		for prop in state_keys do
			 setProperty this.obj prop object_state[prop]

		object_state[#layer].addNode (this.obj)

		for child in object_state[#children] where isValidNode child do child.parent = this.obj
	),

	/** Save modifiers after convert
	  *
	  * Some modifiers can be invalid and cause problem on splines E.g.: Edit_Poly
	  * In this case modifiers are deleted and added again
	  */
	function _saveModifiers =
	(
		--format "\n"; print "SplineConvertor_v._saveModifiers()"
		--format "selection:	% \n" selection[1]

		invalid_modifiers = for _mod in this.obj.modifiers where not validModifier this.obj _mod collect _mod

		--format "INVALID_MODIFIERS:	% \n" invalid_modifiers

		if invalid_modifiers.count > 0 then
		(
			this.modifiers = Dictionary( #integer )

			for i = 1 to this.obj.modifiers.count do
				this.modifiers[i] = this.obj.modifiers[i]
		)

	),

	/** Get modifiers before convert
	  */
	function _loadModifiers =
	(
		--format "\n"; print "SplineConvertor_v._loadModifiers()"

		if this.modifiers != undefined then
			for i = this.modifiers.count to 1 by -1 do
				addModifier this.obj this.modifiers[i]

		this.modifiers = undefined
	),

	/** Delete modifiers
	  */
	function _deleteModifiers =
	(
		--format "\n"; print "SplineConvertor_v._deleteModifiers()"
		if this.modifiers != undefined then
			for i = 1 to this.obj.modifiers.count do
			   deleteModifier this.obj 1
	),

	/** Save user property to obj
	  */
	function _setProperty key val =
	(
		--format "\n"; print "SplineConvertor_v._setProperty()"
		setUserProp  this.obj (key as string ) (val as string )
	),

	/** Get user property from obj
	  */
	function _loadProperty key =
	(
		--format "\n"; print "SplineConvertor_v._setProperty()"
		val = getUserProp this.obj (key as string )

		if val != undefined then
			execute (val)
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "SplineConvertor.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
