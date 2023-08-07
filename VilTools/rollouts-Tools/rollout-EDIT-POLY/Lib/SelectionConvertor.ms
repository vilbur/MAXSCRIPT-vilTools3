/** Selection convertor
 */
struct SelectionConvertor_v
(
	/* construct */
	_mod,

	/* properties */


	/* dependency */
	/* reference */
	/* inhered */
	/** Convert current subobject to given subobject
	  * This method is there because of match methods in EditablePolySelection_v & EditPolySelection_v
	  */
	function convertSelection to_sub_obj =
	(
		format "\n"; print "SelectionConvertor_v.convertSelection()"
		format "FROM	= % \n" (this._getCurrentSubobjectName( subObjectLevel ))
		format "TO	= % \n" to_sub_obj

		if subObjectLevel > 0 then
			_mod.convertSelection (this._getCurrentSubobjectName( subObjectLevel )) to_sub_obj

		subObjectLevel = (this._getCurrentSubobjectInteger(to_sub_obj))
	),

	private

	/** Get current subobject
	 */
	function _getCurrentSubobjectName _subObjectLevel =
	(
		--format "\n"; print "SelectionConvertor_v._getCurrentSubobjectName()"

		case _subObjectLevel of
		(
			1: #vertex
			2: #edge
			3: #border
			4: #face
			5: #element
		)

	),

	/** Get current subobject
	 */
	function _getCurrentSubobjectInteger _subObjectLevel =
	(
		--format "\n"; print "SelectionConvertor_v._getCurrentSubobjectName()"

		case _subObjectLevel of
		(
			#vertex:	1
			#edge:	2
			#border:	3
			#face:	4
			#element:	5
		)

	),
	/**
	 */
	on create do
	(
		_mod = modPanel.getCurrentObject()

		--format "\n"; print "SelectionConvertor.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
