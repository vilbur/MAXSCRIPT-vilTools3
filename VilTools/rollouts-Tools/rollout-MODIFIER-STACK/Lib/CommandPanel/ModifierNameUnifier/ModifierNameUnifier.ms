
/** Modifier names must be unique to get modifers from list box
  *
  * ModifierNameUnifier can find modifiers with same name, or named as base object and rename them temporary
  *
 */
struct ModifierNameUnifier_v
(
	/* construct */
	obj,

	/* properties */
	duplicit_names	= Dictionary (#string),

	--white_space = "                                                 ", -- change is not visible in Command Panel UI
	white_space = "",

	/* dependency */
	/* reference */
	/* inhered */

	/** Find and rename modifiers which has same name as given mod
	  *
	  * @return dictionary KEY: name of modifier with duplicit name VALUE: #( duplicit modifier index )
	  */
	function unify mods =
	(
		--format "\n"; print "ModifierNameUnifier.unify()"
		--format "mods:	% \n" mods
		if classOf mods != Array then mods = #(mods)

		for _mod in mods do
			this._collectDuplicates(_mod)

		--format "\n-----------\nDICTIONARY:duplicit_names:%\n" duplicit_names; for data_pair in duplicit_names do format "%:	%\n" data_pair.key data_pair.value

		this._makeNamesUnique()

		duplicit_names --return
	),

	/** Restore names
	  */
	function restoreNames =
	(
		--format "\n"; print "ModifierNameUnifier_v.revertNames()"
		for data_pair in this.duplicit_names do
			 for _mod in data_pair.value do
				_mod.name =  data_pair.key
	),

	private


	/** Collect duplicates
	  *
	  */
	function _collectDuplicates _mod =
	(
		format "\n"; print "ModifierNameUnifier_v._collectDuplicates()"
		--mod_is_baseobject = _mod == this.obj.baseobject

		baseobject_name = (classOf this.obj.baseobject ) as string

		mod_name = if superClassOf _mod == modifier then _mod.name else baseobject_name

		mods_by_name = this._getModifiersByName (mod_name)

		if (mod_name != baseobject_name and mods_by_name.count > 1) or (mod_name == baseobject_name and mods_by_name.count > 0) then
			this.duplicit_names[mod_name] = mods_by_name
	),


	/** Collect modifiers
	  *
	  */
	function _getModifiersByName mod_name =
	(
		 for _mod in this.obj.modifiers where _mod.name == mod_name collect _mod
	),

	--/** Get modifiers index
	--  *
	--  */
	--function _getModifiersIndex mods =
	--(
	--	--format "\n"; print "ModifierNameUnifier_v.getModifiersIndex()"
	--	for i = 1 to this.obj.modifiers.count where findItem mods this.obj.modifiers[i] > 0 collect i
	--),

	/** Make names unique
	  *
	  */
	function _makeNamesUnique =
	(
		--format "\n"; print "ModifierNameUnifier_v._makeNamesUnique()"

		for data_pair in duplicit_names do
			 for _mod in data_pair.value do
				_mod.name +=  white_space + getHandleByAnim _mod as string

				--this.obj.modifiers[index].name +=  white_space + getHandleByAnim obj.modifiers[index] as string
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ModifierNameUnifier.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
