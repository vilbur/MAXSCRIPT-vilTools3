
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

	prefix = NameIncludes_v(),
	suffix = NameIncludes_v(),

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
		format "this.suffix:	% \n" this.suffix


		this._objects = if classOf _objects == ObjectSet then _objects as Array else _objects


		this.sanitizeBaseName()

		format "base_name:	[%] \n" base_name


		objects_to_rename	= this.InstaceManager.filterUnique(_objects)

		 format "\n"
		 for obj in _objects do format "obj:	%\n" obj.name
		 format "\n"
		 for obj in objects_to_rename do format "objects_to_rename:	%\n" obj.name

		for i = 1 to objects_to_rename.count do
			this._renameObject ( objects_to_rename[i] )( i )
	),

	private

	/** _rename object
	 */
	function _renameObject obj index =
	(
		format "\n-------------\n"; print "ObjectRenamer_v._renameObject()"
		--format "obj.name:	% \n" obj.name
		obj.name = base_name + delimentr + (this._getSuffixNumber index _objects.count )

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
				ins_or_ref_objects[i].name = obj.name + delimentr + data.value + delimentr + (this._getSuffixNumber i ins_or_ref_objects.count)
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
	function _getPrefix obj =
	(
		if prefix_by_parent and obj.parent != undefined then obj.parent.name + "-" else "" --return
	),

	/** _get suffix number
	 */
	function _getSuffixNumber index objects_count =
	(

		digits_prefix	= ""
		index_length	= ( index as string ).count
		count_length	= ( objects_count as string ).count

		if (length_difference = count_length - index_length) > 0 then
			for d = 1 to length_difference do
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