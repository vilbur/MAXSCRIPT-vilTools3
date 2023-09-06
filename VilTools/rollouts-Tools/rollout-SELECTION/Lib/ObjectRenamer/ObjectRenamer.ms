
/** Name includes
 */
struct NameIncludes_v
(
	layer,	-- boolean
	parent,	-- boolean
	type,	-- boolean

	on create do()
)

/** Object renamer
 */
struct ObjectRenamer_v
(
	--__construct = #( #property_name ),

	/* construct */
	/* reference */
	/* inhered */
	/* properties */
	base_name,

	prefix	= NameIncludes_v(),
	sufix	= NameIncludes_v(),

	delimentr = "-",

	_objects,
	objects_to_rename,

	ins_or_ref	= Dictionary #( #INSTANCE, "Inst" ) #( #REFERENCE, "Ref"	 ), -- prefix for instaces or references

	private

	/* dependency */
	InstaceManager = InstaceManager_v(),

	--ascii_lowercase = "abcdefghijklmnopqrstuvwxyz",
	--ascii_uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",


	public

	/** Rename
	 */
	function rename _objects  =
	(
		format "\n"; print "ObjectRenamer_v.rename()"

		format "this.prefix:	% \n" this.prefix
		format "this.sufix:	% \n" this.sufix


		this._objects = if classOf _objects == ObjectSet then _objects as Array else _objects

		this.sanitizeBaseName()

		objects_to_rename	= this.InstaceManager.filterUnique(_objects)

		 --format "\n"
		 --for obj in _objects do format "obj:	%\n" obj.name
		 --format "\n"
		 --for obj in objects_to_rename do format "objects_to_rename:	%\n" obj.name

		for i = 1 to objects_to_rename.count do
			this._renameObject ( objects_to_rename[i] )( i )
	),

	private

	/** _rename object
	 */
	function _renameObject obj index =
	(
		--format "\n-------------\n"; print "ObjectRenamer_v._renameObject()"

		obj.name = (this._getPrefixSufix(obj)(#PREFIX)) + base_name + this._getPrefixSufix(obj)(#SUFIX) + delimentr + (this._getSufixNumber (index) (objects_to_rename.count) )

		this.renameInstancesAndReferences (obj)
	),

	/** Rename instances and references
	  *
	  */
	function renameInstancesAndReferences obj =
	(
		--format "\n"; print "NameIncludes_v.renameInstancesAndReferences()"
		local ins_or_ref_objects

		for data in ins_or_ref do
			for i = 1 to (ins_or_ref_objects = this._getInstancesOrReferences (obj) data.key ).count do
				ins_or_ref_objects[i].name = obj.name + delimentr + data.value + delimentr + (this._getSufixNumber i ins_or_ref_objects.count)
	),


	/** _rename instances
	 */
	function _getInstancesOrReferences obj instance_or_reference =
	(
		--format "\n"; print "ObjectRenamer_v._getInstancesOrReferences()"
		for inst_ref_obj in this.InstaceManager.getInstancesOrReferences(obj)(instance_or_reference) -- get instances or references
			where findItem this._objects inst_ref_obj > 0 and inst_ref_obj != obj -- if in this._objects to rename and is not unique obejcts
				collect inst_ref_obj
	),

	/** _get prefix
	 */
	function _getPrefixSufix obj prefix_sifix_param =
	(
		--format "\n"; print "ObjectRenamer_v._getPrefixSufix()"
		--format "prefix_sifix_param:	% \n" prefix_sifix_param

		/** Set delimeter before or after string
		  */
		function setDelimeter &_string prefix_sifix_param =
		(
			--format "\n"; print "NameIncludes_v.setDelimeter()"
			if  _string != "" then
				case prefix_sifix_param of
				(
					#PREFIX:	_string = _string + this.delimentr
					#SUFIX:	_string = this.delimentr + _string
				)
			else
				_string
		)

		/** Remove prefix or sufix
		  */
		function sanititizeString _string = ( trimRight ( trimLeft _string "_- " )  "_- " )

		prefix_sifix = ""

		NameIncludes = getProperty this prefix_sifix_param

		for prop in #( #layer, #parent, #type ) where ( val = getProperty NameIncludes prop ) != undefined do
		(
			--format "PROP:	% \n" prop
			_string = case prop of
			(
				#parent: if obj.parent != undefined then obj.parent.name else ""
				#layer:  sanititizeString(obj.layer.name)
				#type:  (classOf obj) as string
				default: ""
			)

			setDelimeter(&_string)(prefix_sifix_param)
			--format "OUTPUT:	% \n" _string

			prefix_sifix += _string

			--format "PREFFIX_SIFFIX:	% \n" prefix_sifix
			prefix_sifix --return
		)

		prefix_sifix --return
	),

	/** _get sufix number
	 */
	function _getSufixNumber index objects_count =
	(

		digits_prefix	= ""
		index_length	= ( index as string ).count
		count_length	= ( objects_count as string ).count

		if (length_diference = count_length - index_length) > 0 then
			for d = 1 to length_diference do
				digits_prefix += "0"

		digits_prefix + index as string --return
	),



	/** Sanitize base name
	  *
	  */
	function sanitizeBaseName =
	(
		--format "\n"; print "NameIncludes_v.sanitizeBaseName()"

		base_name = trimRight base_name  "_- " -- left side is left becasuse of custom prefix E.G.: _object-name

		base_name = substituteString base_name " " delimentr
	),

	/**
	 */
	on create do
	(
		print("ObjectRenamer_v.onCreate()")
		--ConstructPropeties test:this
	)
)