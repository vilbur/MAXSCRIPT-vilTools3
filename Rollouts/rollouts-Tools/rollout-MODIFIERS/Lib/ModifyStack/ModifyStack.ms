/** Modify stack
  *
  * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_BAC3CC23_9D1D_44CE_B4AF_C0CEBDD7099E_htm
 */
struct ModifyStack_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	
	
	
	

	
	/** Is pinned
	 */
	function isPinned =
	(
		modpanel.getPinStack()

	),
	
	
	
	/** Get edit poly modifiers
	 */
	function getModifiers obj =
	(
		max modify mode
		
		obj.modifiers --return
	),
	


	
	private
	
	/**  
	 */
	on create do
	(
		print("ModifyStack_v.onCreate()")
	)
	
)
