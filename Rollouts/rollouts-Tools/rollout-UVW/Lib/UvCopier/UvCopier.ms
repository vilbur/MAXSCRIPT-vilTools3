/** Uv copier
 */
struct UvCopier_v
(
	--__construct = #( #property_name ),
	/* construct */
	obj,
	
	source_channel,
	
	target_channel,
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	

	private
	
	/** Copy channethis.
	 */
	function _copyChannel =
	(
		format "\n"; print "UvCopier_v.copyChannel()"
		--format "obj	= % \n" obj
		--format "source_channel	= % \n" source_channel
		--format "target_channel	= % \n" target_channel
		
		if( source_modifier = this._searchForSourceChannel() ) != undefined then 
		(
			format "source_modifier	= % \n" source_modifier
			_Unwrap_UVW_copy = copy source_modifier

			addModifier obj _Unwrap_UVW_copy

			_Unwrap_UVW_copy.unwrap.setMapChannel (target_channel)
		)
		else
			messageBox ("Object "+obj.name+" has not Unwrap modifier with channel " + source_channel as string ) title:"Copy Unwrap_UVW Error"  beep:false
		
		
		
	),
	
	/** Search for Unwrap_UVW with source channel
	 */
	function _searchForSourceChannel =
	(
		--format "\n"; print "UvCopier_v._searchForSourceChannel()"
		for _modifier in obj.modifiers where classOf _modifier == Unwrap_UVW do
			if this._getcurrentChannel(_modifier) == source_channel and source_modifier == undefined then
				source_modifier == _modifier
				
		source_modifier --return
	),
	
	/** Getcurrent channel
	 */
	function _getcurrentChannel _Unwrap_UVW =
	(
		--format "\n"; print "UvCopier_v._getcurrentChannel()"
		if ( _channel = _Unwrap_UVW.unwrap.getMapChannel() ) == 0 then 1 else _channel
	),
	
	/**  
	 */
	on create do
	(
		print("UvCopier_v.onCreate()")
		--ConstructPropeties test:this
		this._copyChannel()
	
	)
	
)
