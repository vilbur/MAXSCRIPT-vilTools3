/** Uv copier
 */
struct UvCopier_v
(
	--__construct = #( #property_name ),
	/* construct */
	_objects,

	source_channel,

	target_channel,

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */

	objects_failed = #(),

	private

	/** Copy channethis.
	 */
	function _copyChannel =
	(
		--format "\n"; print "UvCopier_v.copyChannel()"
		for obj in _objects as Array do
			if classOf obj.baseObject == Editable_Poly then
				this._copyEditablePoly (obj)
			else
				this._copyNonEditablePoly (obj)

		if objects_failed.count == 0 then
			this._returnSuccess()
		else
			this._returnError()
			

	),

	/** Copy editable poly
	 */
	function _copyEditablePoly obj =
	(
		--format "\n"; print "UvCopier_v._copyEditablePoly()"
		if ( polyop.getMapSupport obj target_channel == false ) do polyop.setMapSupport obj target_channel true


		polyop.setNumMapVerts obj target_channel ( polyop.getNumMapVerts obj source_channel) keep:false
		polyop.setNumMapFaces obj target_channel ( polyop.getNumMapFaces obj source_channel) keep:false

		for v = 1 to ( polyop.getNumMapVerts obj target_channel) do 
			polyop.setMapVert obj target_channel v ( polyop.getMapVert obj source_channel v)

		for f = 1 to ( polyop.getNumMapFaces obj target_channel) do
			polyop.setMapFace obj target_channel f (polyop.getMapFace obj source_channel f)

	),

	/** Copy non editable poly
	 */
	function _copyNonEditablePoly obj =
	(
		--format "\n"; print "UvCopier_v.copyNonEditablePoly()"
		if( source_modifier = this._searchForSourceChannel(obj) ) != undefined then 
		(
			--format "source_modifier	= % \n" source_modifier
			_Unwrap_UVW_copy = copy source_modifier

			_Unwrap_UVW_copy.name = "Unwrap UV " + target_channel as string 
			
			addModifier obj _Unwrap_UVW_copy

			_Unwrap_UVW_copy.unwrap.setMapChannel (target_channel)
		)
		else
			append objects_failed obj

	),

	/** Search for Unwrap_UVW with source channel
	 */
	function _searchForSourceChannel obj =
	(
		--format "\n"; print "UvCopier_v._searchForSourceChannel()"
		--format "source_channel	= % \n" source_channel
		local source_modifier

		for _modifier in obj.modifiers where classOf _modifier == Unwrap_UVW do
			if this._getcurrentChannel(_modifier) == source_channel and source_modifier == undefined then
				source_modifier = _modifier

		source_modifier --return
	),

	/** Getcurrent channel
	 */
	function _getcurrentChannel _Unwrap_UVW =
	(
		--format "\n"; print "UvCopier_v._getcurrentChannel()"
		if ( _channel = _Unwrap_UVW.unwrap.getMapChannel() ) == 0 then 1 else _channel
	),

	/** Return success
	 */
	function _returnSuccess =
	(
		format "SUCCESS UVs copy from UV % to UV %\n" source_channel target_channel
		
		true --return
	),
	
	/** Show error
	 */
	function _returnError =
	(
		clearSelection()

		select objects_failed

		messageBox ("Selected objects failed on copy UVs.\n\nThey has not Unwrap modifier with channel " + source_channel as string +" applied probably." ) title:"Copy Unwrap_UVW Error"  beep:true
		
		false --return
	),

	
	
	/**  
	 */
	on create do
	(
		--print("UvCopier_v.onCreate()")
		--ConstructPropeties test:this
		this._copyChannel()

	)

)
